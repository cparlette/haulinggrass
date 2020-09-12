extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	globals.loadLeaderboard()
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir("savedGames")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameButton_pressed():
	get_tree().change_scene("LevelMenu.tscn")

func _on_LeaderboardButton_pressed():
	get_tree().change_scene("Leaderboard.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_NewCampaignButton_pressed():
	globals.campaignPlayer = {}
	get_tree().change_scene("Campaign.tscn")

func _on_LoadCampaignButton_pressed():
	var gameFiles = getSaveGameFiles()
	for file in gameFiles:
		$LoadCampaignMenu/OptionButton.add_item(file.rstrip(".json"))
	$TopMenu.visible = false
	$LoadCampaignMenu.visible = true
	
func getSaveGameFiles():
	var files = []
	var dir = Directory.new()
	dir.open("user://savedGames")
	dir.list_dir_begin(true)
	var file = dir.get_next()
	while file != '':
		files += [file]
		file = dir.get_next()
	return files


func _on_BackToMainButton_pressed():
	$LoadCampaignMenu.visible = false
	$TopMenu.visible = true


func _on_LoadGameButton_pressed():
	var chosenFileId = $LoadCampaignMenu/OptionButton.selected
	var chosenFile = $LoadCampaignMenu/OptionButton.get_item_text(chosenFileId)
	if chosenFileId != -1:
		# Load the game file
		var campaignData = File.new()
		var saveFilePath = "user://savedGames/"+chosenFile+".json"
		print(saveFilePath)
		campaignData.open(saveFilePath,campaignData.READ)
		var tmp_data = campaignData.get_as_text()
		print(tmp_data)
		campaignData.close()
		var tmp_json = parse_json(tmp_data)
		globals.campaignPlayer = {}
		tmp_json['money'] = int(tmp_json['money'])
		tmp_json['experience'] = int(tmp_json['experience'])
		tmp_json['maxMowerHealth'] = int(tmp_json['maxMowerHealth'])
		tmp_json['currentMowerHealth'] = int(tmp_json['currentMowerHealth'])
		globals.campaignPlayer = tmp_json
		$LoadCampaignMenu.visible = false
		$TopMenu.visible = true
		get_tree().change_scene("Campaign.tscn")
