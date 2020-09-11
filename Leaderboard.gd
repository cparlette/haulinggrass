extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/VBoxContainer/LeadersDisplay.visible = false
	$HBoxContainer/VBoxContainer/MenuOptions.visible = true
	for button in get_tree().get_nodes_in_group("LevelLeaderboardButtons"):
		button.connect("pressed", self, "_on_LevelButton_pressed", [button])


func _on_BackButton_pressed():
	$HBoxContainer/VBoxContainer/LeadersDisplay.visible = false
	$HBoxContainer/VBoxContainer/MenuOptions.visible = true

func _on_LevelButton_pressed(button):
	$HBoxContainer/VBoxContainer/LeadersDisplay.visible = true
	$HBoxContainer/VBoxContainer/MenuOptions.visible = false
	var level_chosen = button.name.lstrip("Level").rstrip("LeaderboardButton").to_int()
	var leaders = globals.leaderboard[str(level_chosen)]
	var leaderstext = "Name		Grass Cut		Time\n"
	for item in leaders:
		leaderstext += item["name"] + "		"
		leaderstext += str(item["grassCut"]) + "		"
		leaderstext += str(item["time"]) + "\n"
	$HBoxContainer/VBoxContainer/LeadersDisplay/TextEdit.text = leaderstext


func _on_MainMenuButton_pressed():
	get_tree().change_scene("MainMenu.tscn")
