extends CharacterBody2D

const SPEED = 500

@onready var main = get_tree().get_root()
@onready var projectile = preload("res://Scenes/bass_projectile.tscn")

func _physics_process(delta): #Movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_d") - Input.get_action_strength("ui_a")
	input_vector.y = Input.get_action_strength("ui_s") - Input.get_action_strength("ui_w")
	input_vector = input_vector.normalized()
	
	if input_vector:
		velocity = input_vector * SPEED
	else:
		velocity = input_vector
	move_and_slide()


func attack(): # Attack function...will change with multiple weapons
	
	var waveManager = $"../WaveManager"
	
	if (waveManager.enemiesAlive.size() > 0):
		var proj = projectile.instantiate()
		proj.position = position
		var closestEnemy = waveManager.getClosestEnemyFromSprite($".")
		proj.target = closestEnemy
		proj.varVelocity = (closestEnemy.position - position).normalized()
		get_parent().add_child(proj)
	
