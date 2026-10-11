extends Control

@onready var gameScene = preload("res://Assets/Scenes/game.tscn")
@onready var introScene = preload("res://Assets/Scenes/intro.tscn")

@onready var updatedTxt: Label = $updateNotifier

@onready var gemLine: LineEdit = $GeminiKey/LineEdit
@onready var labLine: LineEdit = $ElevenLabKey/LineEdit

const USER_PATH := "user://secrets.cfg"
const RES_PATH := "res://secrets.cfg"
const KEY_NAMES := ["gemini_key", "elevenlabs_key"]
var keys := {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updatedTxt.visible = false
	_ensure_secrets_file()
	
	fade_out()
	gemLine.text_submitted.connect(gemSubmit)
	labLine.text_submitted.connect(labSubmit)
	pass # Replace with function body.
	
func gemSubmit(txt: String):
	set_key("gemini_key", txt)
	updatedTxt.visible = true
	await get_tree().create_timer(1.0).timeout
	updatedTxt.visible = false
	
func labSubmit(txt: String):
	set_key("elevenlabs_key", txt)
	updatedTxt.visible = true
	await get_tree().create_timer(1.0).timeout
	updatedTxt.visible = false

func _ensure_secrets_file():
	if FileAccess.file_exists(USER_PATH):
		return

	var defaults := ConfigFile.new()
	var has_defaults := defaults.load(RES_PATH) == OK

	var cfg := ConfigFile.new()
	for name in KEY_NAMES:
		var value := ""
		if has_defaults:
			value = str(defaults.get_value("api", name, ""))
		cfg.set_value("keys", name, value)

	var err := cfg.save(USER_PATH)
	if err != OK:
		push_error("Couldn't create secrets file: %s" % err)

func _load_keys() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(USER_PATH) != OK:
		for name in KEY_NAMES:
			keys[name] = ""
		return
	for name in KEY_NAMES:
		keys[name] = str(cfg.get_value("keys", name, ""))	

func get_key(name: String) -> String:
	return keys.get(name, "")
	
func set_key(name: String, value: String) -> void:
	value = value.strip_edges()
	keys[name] = value
	var cfg := ConfigFile.new()
	cfg.load(USER_PATH)
	var load_err := cfg.load(USER_PATH)
	print("load: ", load_err)
	cfg.set_value("keys", name, value)
	cfg.save(USER_PATH)
	var err := cfg.save(USER_PATH)
	print("save: ", err, " -> ", ProjectSettings.globalize_path(USER_PATH))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


	
func playBtn():
	fade_in()
	#self.queue_free()
	#var newIntroScene = introScene.instantiate()
	#get_tree().change_scene_to_node(newIntroScene)
	#self.get_parent().add_child(newIntroScene)
	get_tree().change_scene_to_file("res://Assets/Scenes/intro.tscn")
	
	
func fade_out() -> void:
	var box = get_node("TextureRect")
	box.visible = true
	
	var tween := create_tween()
	tween.tween_property(box, "modulate:a", 0.0, 1.0)
	await tween.finished
	box.visible = false
	
	
func fade_in() -> void:
	var box = get_node("TextureRect")
	var ttween := create_tween()
	ttween.tween_property(box, "modulate:a", 0.0, 0.0)
	box.visible = true
	
	
	var tween := create_tween()
	tween.tween_property(box, "modulate:a", 1.0, 1.0)
	await tween.finished
	
