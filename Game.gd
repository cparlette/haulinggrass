extends Node2D

var timeStart = 0
var timeNow = 0
var newLevelResource

# Called when the node enters the scene tree for the first time.
func _ready():
	var levelFileName = "res://Levels/"+globals.level+".tscn"
	newLevelResource = load(levelFileName)
	var newLevel = newLevelResource.instance()
	var newLevelData = newLevel.get_node("LevelData")
	var newPlayer = newLevel.get_node("Player")
	remove_child($LevelData)
	newLevel.remove_child(newLevelData)
	self.add_child(newLevelData)
	remove_child($Player)
	newLevel.remove_child(newPlayer)
	self.add_child(newPlayer)
	
	globals.grassLeft = $LevelData/Grass.get_used_cells()
	globals.grassCut = 0
	timeStart = OS.get_unix_time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD/GrassCut.set_text("Grass Cut: " + str(globals.grassCut))
	$HUD/GrassLeft.set_text("Grass Left: " + str(globals.grassLeft.size()))
	if globals.grassLeft.size() == 0:
		game_over()
	if globals.playerIsDead == true:
		game_over()
	if $Player.hit == true:
		self.remove_child($Player)
		var newLevel = newLevelResource.instance()
		var newPlayer = newLevel.get_node("Player")
		newLevel.remove_child(newPlayer)
		self.add_child(newPlayer)
	
	timeNow = OS.get_unix_time()
	var elapsed = timeNow - timeStart
	#var minutes = elapsed / 60
	#var seconds = elapsed % 60
	#var str_elapsed = "%02d : %02d" % [minutes, seconds]
	$HUD/TimeElapsed.set_text("Time Elapsed: " + str(elapsed) + "s")
	#print("elapsed : ", str(elapsed))
	
	if globals.campaignMode == true:
		$HUD/MowerHealth.visible = true
		var mowerHealthText = "Mower Health: "
		mowerHealthText += str(globals.campaignPlayer['currentMowerHealth'])
		mowerHealthText += " / "
		mowerHealthText += str(globals.campaignPlayer['maxMowerHealth'])
		$HUD/MowerHealth.set_text(mowerHealthText)
		
		# Check if player health is negative and mark them dead
		# This was a bug before fixing mowers was possible, but good to check
		if globals.campaignPlayer['currentMowerHealth'] < 1:
			globals.playerIsDead = true
	else:
		$HUD/MowerHealth.visible = false
	
	globals.grassLeft = $LevelData/Grass.get_used_cells()

func game_over():
	timeNow = OS.get_unix_time()
	globals.levelTimeElapsed = timeNow - timeStart
	
	get_tree().change_scene("GameOver.tscn")
