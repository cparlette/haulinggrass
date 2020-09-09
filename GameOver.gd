extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if globals.playerIsDead == 1:
		$CanvasLayer/VBoxContainer/GameOverText.set_text("You ran into a fence!")
		$ColorRect.color = Color(1, .1, .1, .5)
	else:
		$CanvasLayer/VBoxContainer/GameOverText.set_text("You mowed all the grass!")
		$ColorRect.color = Color(.14,.94,.14,.5)
	$CanvasLayer/VBoxContainer/GrassCutTotal.set_text("Grass Cut: " + str(globals.grassCut))
	$CanvasLayer/VBoxContainer/GrassLeft.set_text("Grass Left: " + str(globals.grassLeft.size()))
	var minutes = globals.levelTimeElapsed / 60
	var seconds = globals.levelTimeElapsed % 60
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	$CanvasLayer/VBoxContainer/TimeElapsed.set_text("Time Elapsed: " + str_elapsed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_RestartButton_pressed():
	get_tree().change_scene("Game.tscn")

func _on_MainMenuButton_pressed():
	get_tree().change_scene("MainMenu.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
