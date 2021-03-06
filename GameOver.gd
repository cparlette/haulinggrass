extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if globals.playerIsDead == true:
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
	if globals.campaignMode == true:
		$CanvasLayer/VBoxContainer/ArcadeOptions.visible = false
		$CanvasLayer/VBoxContainer/CampaignOptions.visible = true
	else:
		$CanvasLayer/VBoxContainer/CampaignOptions.visible = false
		$CanvasLayer/VBoxContainer/ArcadeOptions.visible = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_RestartButton_pressed():
	get_tree().change_scene("Game.tscn")

func _on_MainMenuButton_pressed():
	get_tree().change_scene("MainMenu.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()


func _on_SubmitNameButton_pressed():
	var leadersubmit = {}
	leadersubmit['name'] = $CanvasLayer/VBoxContainer/ArcadeOptions/LeaderInputHBox/LineEdit.text
	leadersubmit['grassCut'] = globals.grassCut
	leadersubmit['time'] = globals.levelTimeElapsed
	globals.leaderboard[str(globals.level).lstrip("Level")].append(leadersubmit)
	globals.sortLeaderboard()
	globals.saveLeaderboard()
	$CanvasLayer/VBoxContainer/ArcadeOptions/LeaderInputHBox.visible = false


func _on_BackToCampaign_pressed():
	if globals.grassLeft.size() == 0:
		# all grass cut, full experience and money
		globals.campaignPlayer['experience'] += globals.campaignLevels[globals.level]['experienceEarned']
		globals.campaignPlayer['money'] += globals.campaignLevels[globals.level]['moneyEarned']
	elif globals.grassCut > globals.grassLeft.size():
		# majority of grass cut, half experience and half money
		globals.campaignPlayer['experience'] += ( globals.campaignLevels[globals.level]['experienceEarned'] / 2 )
		globals.campaignPlayer['money'] += ( globals.campaignLevels[globals.level]['moneyEarned'] / 2 )
	globals.campaignPlayer['jobLastDone'][globals.level] = globals.campaignPlayer['currentDay']
	globals.campaignPlayer['currentDay'] += 1
	get_tree().change_scene("res://Campaign.tscn")
