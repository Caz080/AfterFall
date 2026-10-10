extends VBoxContainer

@export var fadeTime := 2
@export var stagger := 1


func fade_in_children() -> void:
	var tween := create_tween()
	for child in get_children():
		if child is RichTextLabel:
			child.modulate.a = 0.0
	for child in get_children():
		if child is RichTextLabel:
			tween.tween_property(child, "modulate:a", 1.0, fadeTime)
			tween.tween_interval(stagger-fadeTime if stagger > fadeTime else 0.0)
