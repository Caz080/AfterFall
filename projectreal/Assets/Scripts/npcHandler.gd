extends Node3D

@onready var Hairs = $Head/Hairs.get_children()
@onready var Shirts = $Torso/Shirts.get_children()

@onready var animationPlayer = $AnimationPlayer

@export var firstName: String = "John"
@export var lastName: String = "Doe"
@export var personalityInt: int = 1

@export var npcColor: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$initialCut.emitting = false
	firstName = Global.firstNames.pick_random()
	lastName = Global.lastNames.pick_random()
	personalityInt = randi_range(1, 6)
	npcColor = Color(
		randf(),
		randf(),
		randf()
	)
	#print(name + ": " + firstName + " " + lastName + ", personality: " + var_to_str(personalityInt))
	
	Hairs.pick_random().visible = true
	var randShirt = Shirts.pick_random()
	randShirt.visible = true
	randShirt.modulate = Color(npcColor.r*0.5, npcColor.g*0.5, npcColor.b*0.5)
