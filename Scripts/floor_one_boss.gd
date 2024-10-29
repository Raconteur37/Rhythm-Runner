extends CharacterBody2D

var beamAttackParticle = preload("res://Particles/bossParticleScene.tscn")
var projectile = preload("res://Scenes/Projectiles/lizard_enemy_projectile.tscn")
const bouncer = preload("res://Scenes/CharacterScenes/bouncer_enemy.tscn")
const lizzard = preload("res://Scenes/CharacterScenes/cool_lizard.tscn")
var enemies = ["Bouncer","CoolLizard"]
var beamAttackItem

var health : int = 500
var inCombat : bool = false
var beamReady : bool = false
var shooting : bool = false
var summoning : bool = false
var attackReady : bool = false
var beats : int = 0

var attacks = ["Shooting","Beam","Summoning"]

var screenPositions = [Vector2(0,500),Vector2(0,200),Vector2(0,800)]

func setCombat(val):
	inCombat = val

func setBossBeatTime():
	$BeatTimer.wait_time = PlayerStatManager.getBeatTime()
	$AttackTimer.start(3)

func _ready() -> void:
	$AttackTimer.wait_time = 8

func subtractHealth(dmg : float):
	if health - dmg <= 0:
		print("dead")
	else:
		health = health - dmg

func beamAttack():
	beamReady = true
	beamAttackItem = beamAttackParticle.instantiate()
	beamAttackItem.global_position = screenPositions.pick_random()
	get_parent().add_child(beamAttackItem)
	await get_tree().create_timer(1.5).timeout
	$BeamShoot.play()
	beamAttackItem.get_child(0).emitting = true
	await get_tree().create_timer(1.5).timeout
	beamAttackItem.queue_free()

func _process(delta: float) -> void:
	pass

func _on_attack_timer_timeout() -> void:
	beats = 0
	if attackReady:
		attackReady = false
	else:
		attackReady = true
	$AttackTimer.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player Projectiles"):
		subtractHealth(PlayerStatManager.getDamage())
		body.queue_free()


func _on_beat_timer_timeout() -> void:
	if (inCombat and attackReady):
		if (shooting):
			$BossShoot.stop()
			$BossShoot.play()
			var proj = projectile.instantiate()
			proj.position = position
			proj.linear_velocity = ($"../Player".global_position - position).normalized()  * 1000
			get_parent().add_child(proj)
		beats = beats + 1
		if summoning:
			$Summoning.stop()
			$Summoning.play()
			$"../WaveManager".instanceEnemyType(enemies.pick_random())
		if beats == 4:
			if summoning:
				summoning = false
		if beats >= 8:
			if shooting:
				shooting = false
			var attack = attacks.pick_random()
			if (attack == "Shooting"):
				shooting = true
			if (attack == "Summoning"):
				summoning = true
			if (attack == "Beam"):
				$BeamAppear.play()
				beamAttack()
			beats = 0
