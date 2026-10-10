extends Node3D

@export var firstName: String = "John"
@export var lastName: String = "Doe"
@export var personalityInt: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	firstName = Global.firstNames.pick_random()
	lastName = Global.lastNames.pick_random()
	personalityInt = randi_range(1, 6)
	print(name + ": " + firstName + " " + lastName + ", personality: " + var_to_str(personalityInt))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
