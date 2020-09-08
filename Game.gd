extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bushesTM = get_node("TileMap-bush")
var timeStart = 0
var timeNow = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	globals.grassLeft = bushesTM.get_used_cells()
	globals.grassCut = 0
	print("total bushes = ", globals.grassLeft.size())
	timeStart = OS.get_unix_time()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD/GrassCut.set_text("Grass Cut: " + str(globals.grassCut))
	$HUD/GrassLeft.set_text("Grass Left: " + str(globals.grassLeft.size()))
	if globals.grassLeft.size() == 0:
		game_over()
	if get_node("Player").playerIsDead == 1:
		game_over()
	
	timeNow = OS.get_unix_time()
	var elapsed = timeNow - timeStart
	#var minutes = elapsed / 60
	#var seconds = elapsed % 60
	#var str_elapsed = "%02d : %02d" % [minutes, seconds]
	$HUD/TimeElapsed.set_text("Time Elapsed: " + str(elapsed) + "s")
	#print("elapsed : ", str(elapsed))
	
	globals.grassLeft = bushesTM.get_used_cells()

func game_over():
	timeNow = OS.get_unix_time()
	globals.levelTimeElapsed = timeNow - timeStart
	
	get_tree().change_scene("GameOver.tscn")
