extends Node3D

@export var currentPlayer: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if currentPlayer == null:
		currentPlayer = $Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
