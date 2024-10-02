extends CharacterBody2D

@export var SPEED = 600
var varVelocity = Vector2(0,0)

var target : CharacterBody2D

var dir : float
	
func _physics_process(delta):
	position += varVelocity * (delta * SPEED)
	
	if (is_instance_valid(target)):
		if position.distance_to(target.global_position) < 5:
			get_parent().find_child("WaveManager").removeAliveEnemyFromList(target)
			target.onDeath()
			queue_free()
