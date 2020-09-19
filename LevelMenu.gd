extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in get_tree().get_nodes_in_group("LevelButtons"):
		button.connect("pressed", self, "_on_LevelButton_pressed", [button])

func _on_LevelButton_pressed(button):
	globals.level = button.name.rstrip("Button").replace(" ","")
	get_tree().change_scene("Game.tscn")

func _on_MainMenuButton_pressed():
	get_tree().change_scene("MainMenu.tscn")
