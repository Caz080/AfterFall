extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	var plr = get_node("../../Player")
	plr.active = false
	
	var guess = plr.currentNPC
	
	var sustext = get_node("../RichTextLabel")
	sustext.text = "[shake rate=20.0 level=5 connected=1]And the alien is...[/shake]"
	await get_tree().create_timer(3.0).timeout
	
	
	var win = guess == HttpManager.alien
	
	if win:
		sustext.text = "You got it!"
	else:
		sustext.text = "You lost!"
	
	plr.currentNPC = HttpManager.alien
	
	
	
