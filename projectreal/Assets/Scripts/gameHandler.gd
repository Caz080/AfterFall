extends Node3D

@onready var txtinput = $gameUI/TextureRect/Prompt
@onready var blackFade = $gameUI/BlackFade

@onready var guessBtn = $gameUI/guessBtn

@export var currentPlayer: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if currentPlayer == null:
		currentPlayer = $Player
	blackFade.visible = true
	var tween := create_tween()
	tween.tween_property(blackFade, "modulate:a", 0.0, 1.0)
	await tween.finished
	
	guessBtn.pressed.connect(_on_guess_btn_pressed)
	
	Stt.transcribed.connect(_on_transcribed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if txtinput.text == "" or txtinput.text == "Waiting..." or Stt.listeningtxt == "Listening...":
		txtinput.text = Stt.listeningtxt

func _on_transcribed(t: String) -> void:
	$gameUI/TextureRect/Prompt.text = t
	#caret_column = text.length()
	#print(t)
	var person = currentPlayer
	var textbox = $gameUI/Control/MarginContainer/VBoxContainer/Dialogue
	HttpManager.ask_question(t, currentPlayer.currentNPC, textbox)

func _on_guess_btn_pressed() -> void:
	currentPlayer.active = false
	print("test")
	
	var guess = currentPlayer.currentNPC
	var sustext = $gameUI/guessResult
	sustext.text = "[shake rate=20.0 level=5 connected=1]And the alien is...[/shake]"
	await get_tree().create_timer(3.0).timeout
	
	
	var win = guess == HttpManager.alien
	
	if win:
		sustext.text = "You got it!"
	else:
		sustext.text = "You lost!"
	currentPlayer.currentNPC = HttpManager.alien
