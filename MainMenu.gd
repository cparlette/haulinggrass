extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	globals.loadLeaderboard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameButton_pressed():
	get_tree().change_scene("LevelMenu.tscn")

func _on_SettingsButton_pressed():
	get_tree().change_scene("Settings.tscn")

func _on_LeaderboardButton_pressed():
	get_tree().change_scene("Leaderboard.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
