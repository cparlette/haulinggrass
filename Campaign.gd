extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	globals.campaignMode = true
	$LevelPicker.visible = false
	if globals.campaignPlayer.has('name') == false:
		#new campaign
		$CampaignUI.visible = false
		$NewCampaignMenu.visible = true
	else:
		refreshUI()

func refreshUI():
	$CampaignUI/NameLabel.text = "Name: "+globals.campaignPlayer['name']
	$CampaignUI/ExperienceLabel.text = "Experience: "+str(globals.campaignPlayer['experience'])
	$CampaignUI/MoneyLabel.text = "Money: "+str(globals.campaignPlayer['money'])
	var mowHealthString = "Mower Health: "
	mowHealthString += str(globals.campaignPlayer['currentMowerHealth'])
	mowHealthString += " / "
	mowHealthString += str(globals.campaignPlayer['maxMowerHealth'])
	$CampaignUI/MowerHealthLabel.text = mowHealthString

func _on_NameSubmitButton_pressed():
	globals.campaignPlayer = {
		'name': $NewCampaignMenu/NameEntry.text,
		'experience': 0,
		'money': 10,
		'maxMowerHealth': 5,
		'currentMowerHealth': 5
	}
	globals.savePlayer()
	$NewCampaignMenu.visible = false
	refreshUI()
	$CampaignUI.visible = true


func _on_CancelToMainMenuButton_pressed():
	globals.campaignMode = false
	get_tree().change_scene("MainMenu.tscn")


func _on_SaveAndQuitButton_pressed():
	globals.savePlayer()
	globals.campaignMode = false
	get_tree().change_scene("MainMenu.tscn")


func _on_MowLawnButton_pressed():
	for i in $LevelPicker/CenterContainer/LevelButtons.get_children():
		$LevelPicker/CenterContainer/LevelButtons.remove_child(i)
	var levelsAvailable = getLevelFiles()
	for level in levelsAvailable:
		var button = Button.new()
		button.name = level.rstrip(".tscn")
		button.text = button.name
		button.connect("pressed", self, "_on_LevelButton_pressed", [button])
		$LevelPicker/CenterContainer/LevelButtons.add_child(button)
	$CampaignUI.visible = false
	$LevelPicker.visible = true

func _on_LevelButton_pressed(button):
	globals.level = button.name
	get_tree().change_scene("Game.tscn")

func getLevelFiles():
	var files = []
	var dir = Directory.new()
	dir.open("res://Levels")
	dir.list_dir_begin(true)
	var file = dir.get_next()
	while file != '':
		files += [file]
		file = dir.get_next()
	return files

func _on_CloseLevelPickerButton_pressed():
	$LevelPicker.visible = false
	$CampaignUI.visible = true


func _on_RepairMowerButton_pressed():
	# FIXME - need to add logic here around paying
	#globals.campaignPlayer['currentMowerHealth'] = globals.campaignPlayer['maxMowerHealth']
	#refreshUI()
	$CampaignUI/RepairPopupMenu.rect_position = $CampaignUI/RepairMowerButton.rect_position
	$CampaignUI/RepairPopupMenu.popup()


func _on_RepairPopupMenu_index_pressed(index):
	if index == 0:
		# heal 1
		if globals.campaignPlayer['currentMowerHealth'] < globals.campaignPlayer['maxMowerHealth']:
			globals.campaignPlayer['currentMowerHealth'] += 1
			globals.campaignPlayer['money'] -= 5
	elif index == 1:
		# heal all
		globals.campaignPlayer['currentMowerHealth'] = globals.campaignPlayer['maxMowerHealth']
		globals.campaignPlayer['money'] -= costToHealAll()
	elif index == 2:
		# cancel button
		pass

func costToHealAll():
	var lostHealth = globals.campaignPlayer['maxMowerHealth'] - globals.campaignPlayer['currentMowerHealth']
	return int(lostHealth * 5)

func _on_RepairPopupMenu_about_to_show():
	var repairAllText = "Repair All - $" + str(costToHealAll())
	$CampaignUI/RepairPopupMenu.set_item_text(1, repairAllText)

func _on_RepairPopupMenu_popup_hide():
	refreshUI()
