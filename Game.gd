extends Node2D

var timeStart = 0
var timeNow = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var levelFileName = "res://Levels/"+globals.level+".tscn"
	var newLevelResource = load(levelFileName)
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
	if globals.playerIsDead == 1:
		game_over()
	
	timeNow = OS.get_unix_time()
	var elapsed = timeNow - timeStart
	#var minutes = elapsed / 60
	#var seconds = elapsed % 60
	#var str_elapsed = "%02d : %02d" % [minutes, seconds]
	$HUD/TimeElapsed.set_text("Time Elapsed: " + str(elapsed) + "s")
	#print("elapsed : ", str(elapsed))
	
	globals.grassLeft = $LevelData/Grass.get_used_cells()

func game_over():
	timeNow = OS.get_unix_time()
	globals.levelTimeElapsed = timeNow - timeStart
	
	get_tree().change_scene("GameOver.tscn")
