extends CharacterBody2D

const SPEED = 500

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

@onready var main = get_tree().get_root()
@onready var projectile = preload("res://Scenes/bass_projectile.tscn")

var immune : bool

func _physics_process(delta): #Movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_d") - Input.get_action_strength("ui_a")
	input_vector.y = Input.get_action_strength("ui_s") - Input.get_action_strength("ui_w")
	input_vector = input_vector.normalized()
	
	if input_vector:
		velocity = input_vector * SPEED
	else:
		velocity = input_vector
		
	if Input.get_action_strength("ui_d"):
		ap.play("run_right")
	if Input.get_action_strength("ui_a"):
		ap.play("walk_left")
	if Input.get_action_strength("ui_w"):
		ap.play("walking_up")
	if velocity == Vector2(0,0):
		ap.play("idle")
	move_and_slide()
	
	
	for enemy in $"../WaveManager".enemiesAlive:
		if (is_instance_valid(enemy)):
			if position.distance_to(enemy.global_position) < 40 and immune != true:
				wasHit()
		
	

func wasHit():
	immune = true
	$"../GameCamera".add_trauma(.8)
	# play other animation
	# play sound effect
	await get_tree().create_timer(2).timeout
	immune = false
	

func attack(): # Attack function...will change with multiple weapons
	
	#print($"../WaveManager".enemiesAlive)
	
	var waveManager = $"../WaveManager"
	
	if (waveManager.enemiesAlive.size() > 0):
		var proj = projectile.instantiate()
		proj.position = position
		var closestEnemy = waveManager.getClosestEnemyFromSprite($".")
		proj.target = closestEnemy
		proj.varVelocity = (closestEnemy.position - position).normalized()
		get_parent().add_child(proj)
	
