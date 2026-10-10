extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade_out()
	pass # Replace with function body.


func fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	
func fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	await tween.finished
