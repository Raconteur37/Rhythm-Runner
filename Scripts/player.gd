extends CharacterBody2D

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hitFlashAnimation = $HitFlashAnimation

var tutorial = false
var tutorialShoot = false

@export var tempo : float = 0
var beatTime : float
var count : int = 0
var lenientTime 
var canShoot : bool = false
var lowerBound : float
var upperBound : float

var isDashing = false
var canDash = true

@onready var main = get_tree().get_root()
@onready var projectile = preload("res://Scenes/Projectiles/bass_bullet.tscn")
@onready var beatExplosionScene = preload("res://Particles/beat_particle.tscn")

var immune : bool
var hitAnimation = false

func setBeatTimer(tempo):
	$PlayerBeatTimer.stop()
	beatTime = float(60) / tempo
	$PlayerBeatTimer.wait_time = beatTime
	PlayerStatManager.setBeatTime(beatTime)
	
	if beatTime < .4:
		lenientTime = beatTime * .5
	else:
		lenientTime = beatTime * .3
		
	upperBound = beatTime - lenientTime
	lowerBound = lenientTime
	
	print(str(lowerBound) + "-" + str(upperBound))
	
	$PlayerBeatTimer.start(0)

func _ready() -> void:
	pass

func _physics_process(delta): #Movement
	
	if PlayerStatManager.getInWave() and !hitAnimation or tutorial:
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
			move_and_slide()
			pauseCooldown()


func pauseCooldown():
	await get_tree().create_timer(.6).timeout
	if (canDash):
		if not tutorial:
			$"../ControlPlayerUI/PlayerUI/DashLabel".label_settings = load("res://Labels/UncompletedLabel.tres")
			$"../ControlPlayerUI/PlayerUI/DashLabel".text = ""
		canDash = false
		$DashCooldown.start(PlayerStatManager.getDashCooldown())
		dashStartup()

func wasHit():
	hitAnimation = true
	PlayerStatManager.setPlayerImmune(true)
	$"../GameCamera".add_trauma(.8)
	PlayerStatManager.takeDamage()
	if (PlayerStatManager.getHealth() < 0):
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		PlayerStatManager.isDead = true
		return
	if (PlayerStatManager.getHealth() == 2):
		$"../ControlPlayerUI/PlayerUI/HBoxContainer2/HealthPotion3".visible = false
	if (PlayerStatManager.getHealth() == 1):
		$"../ControlPlayerUI/PlayerUI/HBoxContainer2/HealthPotion2".visible = false
	if (PlayerStatManager.getHealth() == 0):
		$"../ControlPlayerUI/PlayerUI/HBoxContainer2/HealthPotion1".visible = false
	$"../GameCamera".follow_node = $"."
	$"../AnimationPlayer".play("PlayerDamage")
	ap.play("drinkPotion")
	$"../AnimationPlayer/DownSound".play()
	$"../Music".volume_db = -80
	await get_tree().create_timer(3).timeout
	hitAnimation = false
	$"../AnimationPlayer".play("PlayerDamageDone")
	$"../GameCamera".follow_node = $"../GameCamera"
	$"../GameCamera".position = Vector2(983,450)
	if not PlayerStatManager.getIsInBossFight():
		$"../Music".volume_db = 1
	hitFlashAnimation.play("HitFlash")
	await get_tree().create_timer(PlayerStatManager.getImmuneTime()).timeout
	PlayerStatManager.setPlayerImmune(false)
	
func _input(event: InputEvent):
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_SPACE and tutorialShoot:
		var currentTime = $PlayerBeatTimer.time_left
		#print(currentTime)
		if lowerBound >= currentTime or currentTime >= upperBound:
			canShoot = true
		else:
			canShoot = true # CHAGNE BACK TO FALSE TODO 
		#if lowerBound <= currentTime and currentTime <= upperBound: #Bluetooth
		#	canShoot = true
		#else:
		#	canShoot = false
		if canShoot and PlayerStatManager.getInWave():
			attack()
			var beatExplosion = beatExplosionScene.instantiate()
			beatExplosion.global_position = $"../ControlPlayerUI/PlayerUI/HBoxContainer/BassParticlePosition".global_position
			beatExplosion.emitting = true
			beatExplosion.one_shot = true
			get_tree().current_scene.find_child("PlayerUI").add_child(beatExplosion)
			#print(beatExplosion.emitting)
		elif canShoot and tutorial:
			attack()
		else:
			if PlayerStatManager.getInWave():
				$"../GameCamera".add_trauma(.5)
		#print($"../BeatTimer".time_left)

func attack(): # Attack function...will change with multiple weapons
	
	if tutorial:
		$"../CanvasLayer".beats = $"../CanvasLayer".beats + 1
		var closestEnemy = $"../CanvasLayer".getClosestEnemyFromSprite($".")
			#proj.apply_impulse((closestEnemy.position - position).normalized(),Vector2(bulletSpeed,0))
		if is_instance_valid(closestEnemy):
			var proj = projectile.instantiate()
			proj.position = position
			proj.linear_velocity = (closestEnemy.position - position).normalized() * PlayerStatManager.getProjectileSpeed()
			get_parent().add_child(proj)
		
	else:
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

func dashStartup():
	if not tutorial:
		for x in range(5):
			if x == 0:
				$"Dash SFX".play(0)
				$"../ControlPlayerUI/PlayerUI/DashLabel".text = "D"
				await get_tree().create_timer(.3).timeout
				$"Dash SFX".stop()
			if x == 1:
				$"Dash SFX".play(1)
				$"../ControlPlayerUI/PlayerUI/DashLabel".text = "DA"
				await get_tree().create_timer(.3).timeout
				$"Dash SFX".stop()
			if x == 2:
				$"Dash SFX".play(2)
				$"../ControlPlayerUI/PlayerUI/DashLabel".text = "DAS"
				await get_tree().create_timer(.3).timeout
				$"Dash SFX".stop()
			if x == 3:
				$"Dash SFX".play(3)
				$"../ControlPlayerUI/PlayerUI/DashLabel".text = "DASH"
				await get_tree().create_timer(.3).timeout
				$"Dash SFX".stop()
			if x == 4:
				$"Dash SFX".play(4)
				$"../ControlPlayerUI/PlayerUI/DashLabel".text = "DASH!"
				await get_tree().create_timer(.3).timeout
				$"Dash SFX".stop()
			await get_tree().create_timer((PlayerStatManager.getDashCooldown() / 5) - .3).timeout
		$"../ControlPlayerUI/PlayerUI/DashLabel".label_settings = load("res://Labels/CompletedLabel.tres")

func _on_dash_cooldown_timeout() -> void:
	canDash = true
	$DashCooldown.wait_time = PlayerStatManager.getDashCooldown()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.


func _on_hit_flash_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "HitFlash":
		if PlayerStatManager.isPlayerImmune():
			hitFlashAnimation.play("HitFlash")
