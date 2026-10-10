extends Label


func _ready():
	Stt.transcribed.connect(_on_transcribed)

func _on_transcribed(t: String) -> void:
	text = t
	#caret_column = text.length()
	#print(t)
	var person = get_node("../../../Player")
	var textbox = get_node("../../Control/MarginContainer/VBoxContainer/Dialogue")
	HttpManager.ask_question(t, person.currentNPC, textbox)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = Stt.listeningtxt
	#pass
	#if Input.is_action_pressed("ui_accept"):
		
	
	#if Input.is_action_just_pressed("ui_accept"):
		
	#	var t = self.text
		
	#	var textbox = get_node("../../../../Control/MarginContainer/VBoxContainer/Dialogue")
		
	#	textbox.typeText("hajkfhdjkfsfjksdkjfv hdkjfhskfhksdfhjks khsjkfh")
		
	#	var person = 1
		#HttpManager.ask_question(t, person, textbox)
