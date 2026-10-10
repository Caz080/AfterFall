extends Node3D

@onready var moveLeftButton = $UI/moveLeftButton
@onready var moveRightButton = $UI/moveRightButton

@export var currentCamera: Camera3D

@export var currentNPC: int = 1:
	set(new_val):
		if currentNPC != new_val:
			if new_val > 6:
				new_val = 6
			elif new_val < 1:
				new_val = 1
			currentNPC = new_val
			update_camera()

# between 90 to -90 (180 diff)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_camera()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		currentNPC -= 1
	elif Input.is_action_just_pressed("move_right"):
		currentNPC += 1

func update_camera():
	if currentCamera:
		rotation_degrees.y = 90 - ((currentNPC-1)*36)
	
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


func _on_move_right_button_pressed() -> void:
	currentNPC += 1


func _on_move_left_button_pressed() -> void:
	currentNPC -= 1
