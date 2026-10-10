extends RichTextLabel

@export var charspersec := 40.0
var _typing := false

func typeText(text: String):
	visible_characters = 0
	_typing = true
	self.text = "[wave amp=20 freq=5]"+text+"[/wave]"
	var total := text.length()
	while visible_characters < total:
		visible_characters+=1
		var c := get_parsed_text()[visible_characters-1]
		var delay := 1.0/charspersec
		if c in ".!?":
			delay *= 8.0
		elif c == ",":
			delay *= 4.0
		await get_tree().create_timer(delay).timeout
		if not _typing:
			return
	_typing = false
	
func skip() -> void:
	_typing = false
	visible_characters = -1
		
