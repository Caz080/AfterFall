extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade_out()
	var text = get_node("CanvasLayer/VBoxContainer")
	
	text.fade_in_children()
	await get_tree().create_timer(10.0).timeout
	fade_in()
	
	get_tree().change_scene_to_file("res://Assets/Scenes/game.tscn")
	


	
	
func fade_out() -> void:
	var box = get_node("CanvasLayer/TextureRect2")
	
	var tween := create_tween()
	tween.tween_property(box, "modulate:a", 0.0, 1.0)
	await tween.finished
	
func fade_in() -> void:
	var box = get_node("CanvasLayer/TextureRect2")
	
	var tween := create_tween()
	tween.tween_property(box, "modulate:a", 1.0, 1.0)
	await tween.finished
