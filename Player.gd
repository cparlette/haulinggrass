extends KinematicBody2D

var moveSpeed = 250
var grassCutTotal = 0
var vel = Vector2()
var facingDir = Vector2()
var hit = false

onready var rayCast = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	globals.playerIsDead = false

func _physics_process (delta):
	#use this to have movement stopped unless you press a key
	#vel = Vector2()
	# inputs
	if Input.is_action_pressed("move_up"):
		vel.x = 0
		vel.y = -1
		facingDir = Vector2(-1, 0)
	if Input.is_action_pressed("move_down"):
		vel.x = 0
		vel.y = 1
		facingDir = Vector2(1, 0)
	if Input.is_action_pressed("move_left"):
		vel.x = -1
		vel.y = 0
		facingDir = Vector2(0, 1)
	if Input.is_action_pressed("move_right"):
		vel.x = 1
		vel.y = 0
		facingDir = Vector2(0, -1)
 
	# normalize the velocity to prevent faster diagonal movement
	vel = vel.normalized()
 
	# move the player
	rotation = facingDir.angle()
	move_and_slide(vel * moveSpeed, Vector2.ZERO)
	
	#if player hit a bush, increment points and delete bush
	if get_slide_count():
		var collision = get_slide_collision(0)
		if collision.collider.name == "Grass":
			var tilemap = get_parent().get_node("LevelData/Grass")
			var cell = tilemap.world_to_map(collision.position - collision.normal)
			tilemap.set_cell(cell.x, cell.y, -1)
			globals.grassCut += 1
		if collision.collider.name == "Fence":
			if globals.campaignMode == false:
				globals.playerIsDead = true
			else:
				globals.campaignPlayer['currentMowerHealth'] -= 1
				if globals.campaignPlayer['currentMowerHealth'] == 0:
					globals.playerIsDead = true
				else:
					hit = true
	
