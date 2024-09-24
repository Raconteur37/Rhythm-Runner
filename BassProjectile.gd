extends CharacterBody2D

@export var SPEED = 100
var bulletVelocity = Vector2(0,1)

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(delta):
	var collision = move_and_collide(bulletVelocity.normalized() * delta * SPEED)
