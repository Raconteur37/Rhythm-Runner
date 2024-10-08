extends CharacterBody2D

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

var isDashing = false
var canDash = true

@onready var main = get_tree().get_root()
@onready var waveManager = $"../WaveManager"
@onready var projectile = preload("res://Scenes/Projectiles/bass_bullet.tscn")

var immune : bool
var hitAnimation = false

func _physics_process(delta): #Movement
	
	if waveManager.inWave and !hitAnimation:
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_d") - Input.get_action_strength("ui_a")
		input_vector.y = Input.get_action_strength("ui_s") - Input.get_action_strength("ui_w")
		input_vector = input_vector.normalized()
		
		if input_vector:
			velocity = input_vector * PlayerStatManager.getSpeed()
		else:
			velocity = input_vector
			
		if Input.get_action_strength("ui_d"):
			ap.play("run_right")
		if Input.get_action_strength("ui_a"):
			ap.play("walk_left")
		if Input.get_action_strength("ui_w"):
			ap.play("walking_up")
		if Input.get_action_strength("ui_s"):
			ap.play("walking_down")
		if Input.get_action_strength("ui_info"):
			print(PlayerStatManager.toString())
		if velocity == Vector2(0,0):
			ap.play("idle")
		if Input.get_action_strength("ui_dash") and canDash:
			ap.play("dash")
			isDashing = true
		move_and_slide()
		
		if isDashing:
			PlayerStatManager.isImmune = true
			velocity = input_vector * PlayerStatManager.getDashSpeed()
			isDashing = false
			PlayerStatManager.isImmune = false
			$DashCooldown.start(PlayerStatManager.getDashCooldown())
			move_and_slide()
			pauseCooldown()


func pauseCooldown():
	await get_tree().create_timer(.6).timeout
	canDash = false

func wasHit():
	hitAnimation = true
	PlayerStatManager.setPlayerImmune(true)
	$"../GameCamera".add_trauma(.8)
	PlayerStatManager.setHealth(PlayerStatManager.getHealth() - 1)
	if (PlayerStatManager.getHealth() == 0):
		print("game over")
	
	$"../GameCamera".follow_node = $"."
	$"../AnimationPlayer".play("PlayerDamage")
	ap.play("drinkPotion")
	$"../AnimationPlayer/DownSound".play()
	$"../AudioStreamPlayer2D".volume_db = -80
	await get_tree().create_timer(3).timeout
	hitAnimation = false
	$"../AnimationPlayer".play("PlayerDamageDone")
	$"../GameCamera".follow_node = $"../GameCamera"
	$"../GameCamera".position = Vector2(983,450)
	$"../AudioStreamPlayer2D".volume_db = 1
	await get_tree().create_timer(2).timeout
	PlayerStatManager.setPlayerImmune(false)
	

func attack(): # Attack function...will change with multiple weapons
	
	#print($"../WaveManager".enemiesAlive)
	
	var waveManager = $"../WaveManager"
	
	if (waveManager.enemiesAlive.size() > 0):
		if (PlayerStatManager.hasWand()):
			PlayerStatManager.addShot()
			print(PlayerStatManager.getShotNumber())
			if (PlayerStatManager.getShotNumber() == PlayerStatManager.getShotActivationNumber()):
				PlayerStatManager.resetShot()
				for enemy in waveManager.enemiesAlive:
					if is_instance_valid(enemy):
						var proj = projectile.instantiate()
						proj.position = position
						proj.linear_velocity = (enemy.position - position).normalized() * PlayerStatManager.getProjectileSpeed()
						proj.name = "PlayerBassBullet"
						get_parent().add_child(proj)
		var closestEnemy = waveManager.getClosestEnemyFromSprite($".")
		#proj.apply_impulse((closestEnemy.position - position).normalized(),Vector2(bulletSpeed,0))
		if is_instance_valid(closestEnemy):
			var proj = projectile.instantiate()
			proj.position = position
			proj.linear_velocity = (closestEnemy.position - position).normalized() * PlayerStatManager.getProjectileSpeed()
			get_parent().add_child(proj)
			var randNum = randf_range(1,101)
			if (randNum <= PlayerStatManager.getExtraProjectileChance()):
				proj = projectile.instantiate()
				proj.position = position
				proj.linear_velocity = (closestEnemy.position - position).normalized() * PlayerStatManager.getProjectileSpeed()
				get_parent().add_child(proj)


func _on_area_2d_body_entered(body: Node2D) -> void:
	var randNum = randf_range(1,101)
	if (randNum >= PlayerStatManager.getBlockChance()):
		if body.is_in_group("Enemy Projectiles"):
			if not PlayerStatManager.isPlayerImmune():
				wasHit()
				body.queue_free()
		if body.is_in_group("Enemy"):
			if not PlayerStatManager.isPlayerImmune():
				wasHit()


func _on_dash_cooldown_timeout() -> void:
	canDash = true
	$DashCooldown.wait_time = PlayerStatManager.getDashCooldown()
	
