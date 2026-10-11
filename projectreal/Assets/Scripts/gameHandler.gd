extends Node3D

@onready var mainMenuScene = preload("res://Assets/Scenes/main.tscn")

@onready var revolverSprite = preload("res://Assets/Sprites/Sprite-Revolver.png")
@onready var revolverHoverSprite = preload("res://Assets/Sprites/Sprite-RevolverHover.png")

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
	blackFade.visible = false
	
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
	if not currentPlayer.active: return
	$gameUI/Control.visible = false
	$gameUI/guessBtn.visible = false
	$gameUI/TextureRect.visible = false
	currentPlayer.get_node("UI").visible = false
	$gameUI/guessBtn/AnimationPlayer.play("shoot")
	$shootAudio.play()
	$GuessAudio.play(0.39)
	var chosenNpc = get_node("NPC_" + var_to_str(currentPlayer.currentNPC))
	chosenNpc.get_node("AnimationPlayer").play("killAnim")
	currentPlayer.active = false
	print("test")
	
	var guess = currentPlayer.currentNPC
	var sustext = $gameUI/guessResult
	sustext.text = "[shake rate=20.0 level=5 connected=1]And the alien is...[/shake]"
	$clockBg.stop()
	$buildupAudio.play()
	var camTween = create_tween()
	camTween.tween_property($Player/Offset/MainCamera, "fov", 45, 3)
	camTween.play()
	await get_tree().create_timer(3.0).timeout
	
	
	var win = guess == HttpManager.alien
	var alienNpc = get_node("NPC_" + var_to_str(HttpManager.alien))
	
	$scarystringsfx.play()
	currentPlayer.currentNPC = HttpManager.alien
	camTween = create_tween()
	camTween.tween_property($Player/Offset/MainCamera, "fov", 75, 0.25)
	camTween.play()
	if win:
		sustext.text = "[tornado radius=5 freq=5]Dead![/tornado]"
		blackFade.visible = true
		await get_tree().create_timer(3.0).timeout
		blackFade.visible = true
		var tween := create_tween()
		tween.tween_property(blackFade, "modulate:a", 1.0, 1.0)
		await tween.finished
	else:
		sustext.text = ""
		await get_tree().create_timer(0.25).timeout
		alienNpc.get_node("AnimationPlayer").play("isAlien")
		$screamSfx.play()
		await get_tree().create_timer(1.5).timeout
		blackFade.visible = true
		var tween := create_tween()
		tween.tween_property(blackFade, "modulate:a", 1.0, 0.0)
		$screamSfx.stop()
		$cutAudio.play()
	await get_tree().create_timer(4).timeout
	#var parentNode = self.get_parent()
	#self.queue_free()
	#await self.tree_exited
	#var newMainMenuScene = mainMenuScene.instantiate()
	#parentNode.add_child(newMainMenuScene)
	#get_tree().change_scene_to_node(newMainMenuScene)
	get_tree().change_scene_to_file("res://Assets/Scenes/main.tscn")


func _on_gun_model_mouse_entered() -> void:
	if not currentPlayer.active: return
	$gameUI/gunModel.texture = revolverHoverSprite

func _on_gun_model_mouse_exited() -> void:
	if not currentPlayer.active: return
	$gameUI/gunModel.texture = revolverSprite
