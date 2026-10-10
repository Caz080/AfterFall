extends Node3D

@export var currentCamera: Camera3D

@export var currentNPC: int = 1:
	set(new_val):
		if currentNPC != new_val:
			currentNPC = new_val
			update_camera()

# between 90 to -90 (180 diff)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_camera()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_camera():
	if currentCamera:
		rotation_degrees.y = 90 - ((currentNPC-1)*36)
