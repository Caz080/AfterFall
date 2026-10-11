extends Node3D

@onready var moveLeftButton = $UI/moveLeftButton
@onready var moveRightButton = $UI/moveRightButton

@onready var buttonClick: AudioStreamPlayer = $buttonAudio

@export var currentCamera: Camera3D
var active = true

@export var currentNPC: int = 1:
	set(new_val):
		if currentNPC != new_val:
			if new_val > 6:
				new_val = 6
			elif new_val < 1:
				new_val = 1
			currentNPC = new_val
			buttonClick.play()
			update_camera()
			show_name()

var rotation_dur: float = 0.4
var camTween: Tween

# between 90 to -90 (180 diff)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_name()
	update_camera()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		if Input.is_action_just_pressed("move_left"):
			currentNPC -= 1
		elif Input.is_action_just_pressed("move_right"):
			currentNPC += 1

func update_camera():
	if currentCamera:
		faceDir()
		#rotation_degrees.y = 90 - ((currentNPC-1)*36)

	
	if not is_inside_tree():
		return
	
	if currentNPC == 1:
		moveLeftButton.visible = false
	else:
		moveLeftButton.visible = true
	
	if currentNPC == 6:
		moveRightButton.visible = false
	else:
		moveRightButton.visible = true

func faceDir() -> void:
	var target_angle = 90 - ((currentNPC-1)*36)#atan2(-flat_dir.x, -flat_dir.z)
	
	if camTween and camTween.is_valid():
		camTween.kill()
	
	camTween = create_tween()
	camTween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	camTween.tween_method(
		_apply_rotation.bind(rotation_degrees.y, target_angle),
		0.0,
		1.0,
		rotation_dur
	)

func _apply_rotation(weight: float, start: float, target: float) -> void:
	rotation_degrees.y = lerp(start, target, weight)

func _on_move_right_button_pressed() -> void:
	if not active: return
	currentNPC += 1

func _on_move_left_button_pressed() -> void:
	if not active: return
	currentNPC -= 1
	
func show_name():
	var personname = get_node("../gameUI/Control/MarginContainer/VBoxContainer/Person")
	var npc = get_node("../NPC_"+str(currentNPC))
	personname.text = npc.firstName + " " + npc.lastName
	personname.add_theme_color_override("font_color", npc.npcColor)
	
	var textbox = get_node("../gameUI/Control/MarginContainer/VBoxContainer/Dialogue")
	textbox.text = ""
