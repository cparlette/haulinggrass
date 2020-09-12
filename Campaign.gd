extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
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
		'money': 0,
		'maxMowerHealth': 5,
		'currentMowerHealth': 5
	}
	globals.savePlayer()
	$NewCampaignMenu.visible = false
	refreshUI()
	$CampaignUI.visible = true


func _on_CancelToMainMenuButton_pressed():
	get_tree().change_scene("MainMenu.tscn")


func _on_SaveAndQuitButton_pressed():
	globals.savePlayer()
	get_tree().change_scene("MainMenu.tscn")
