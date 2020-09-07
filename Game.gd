extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bushesTM = get_node("TileMap-bush")



# Called when the node enters the scene tree for the first time.
func _ready():
	globals.grassLeft = bushesTM.get_used_cells()
	globals.grassCut = 0
	print("total bushes = ", globals.grassLeft.size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD/GrassCut.set_text("Grass Cut:" + str(globals.grassCut))
	$HUD/GrassLeft.set_text("Grass Left:" + str(globals.grassLeft.size()))
	if globals.grassLeft.size() == 0:
		game_over()
	if get_node("Player").playerIsDead == 1:
		game_over()
	
	globals.grassLeft = bushesTM.get_used_cells()

func game_over():
	get_tree().change_scene("GameOver.tscn")
