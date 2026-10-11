extends Node


var record: AudioEffectRecord
var http := HTTPRequest.new()

const URL := "https://api.elevenlabs.io/v1/speech-to-text"
const MODEL_ID := "scribe_v1"

var listeningtxt = "Waiting..."

var secrets = ConfigFile.new()
var err = secrets.load("user://secrets.cfg")
var voicekey = secrets.get_value("keys","elevenlabs_key","")

signal transcribed(text: String)

func _ready() -> void:
	add_child(http)
	http.request_completed.connect(_on_response)
	
	var mic := AudioStreamPlayer.new()
	mic.stream = AudioStreamMicrophone.new()
	mic.bus = "Record"
	add_child(mic)
	mic.play()
	
	var idx := AudioServer.get_bus_index("Record")
	record = AudioServer.get_bus_effect(idx, 0)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("push_to_talk") and not event.is_echo():
		#print("listening...")
		listeningtxt = "Listening..."
		record.set_recording_active(true)
		get_viewport().set_input_as_handled()
	elif event.is_action_released("push_to_talk"):
		#print("stopped listening")
		listeningtxt = "Waiting..."
		record.set_recording_active(false)
		_send_recording(record.get_recording())
		get_viewport().set_input_as_handled()
		


func _send_recording(rec: AudioStreamWAV) -> void:
	if rec == null or rec.data.is_empty():
		return
	var path := "user://speech.wav"
	rec.save_to_wav(path)  
	var wav_bytes := FileAccess.get_file_as_bytes(path)

	var boundary := "----GodotFormBoundary7MA4YWxk"
	var body := PackedByteArray()

	# model_id field
	body.append_array(("--%s\r\n" % boundary).to_utf8_buffer())
	body.append_array("Content-Disposition: form-data; name=\"model_id\"\r\n\r\n".to_utf8_buffer())
	body.append_array((MODEL_ID + "\r\n").to_utf8_buffer())

	# file field
	body.append_array(("--%s\r\n" % boundary).to_utf8_buffer())
	body.append_array("Content-Disposition: form-data; name=\"file\"; filename=\"speech.wav\"\r\n".to_utf8_buffer())
	body.append_array("Content-Type: audio/wav\r\n\r\n".to_utf8_buffer())
	body.append_array(wav_bytes)
	body.append_array("\r\n".to_utf8_buffer())

	# closing boundary
	body.append_array(("--%s--\r\n" % boundary).to_utf8_buffer())

	var headers := [
		"xi-api-key: " + voicekey,
		"Content-Type: multipart/form-data; boundary=" + boundary,
	]
	http.request_raw(URL, headers, HTTPClient.METHOD_POST, body)

func _on_response(_result, code, _headers, body: PackedByteArray) -> void:
	if code != 200:
		push_error("STT failed: %s %s" % [code, body.get_string_from_utf8()])
		return
	var data = JSON.parse_string(body.get_string_from_utf8())
	transcribed.emit(str(data["text"]).strip_edges())
	
