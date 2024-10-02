extends CharacterBody2D

@export var SPEED = 600
var varVelocity = Vector2(0,0)

var target : CharacterBody2D

func _ready() -> void:
	rotate(position.angle_to_point(target.position))
	

func _physics_process(delta: float) -> void:
	
	position += varVelocity * (delta * SPEED)
	
	if position.distance_to(target.global_position) < 25:
		target.wasHit() # Works for now since target is always the player
		queue_free()
