extends CharacterBody2D

var beamAttackParticle = preload("res://Particles/bossParticleScene.tscn")

var health : int = 1000
var inCombat : bool = false
var beamReady : bool = false
var shooting : bool = false
var beats : int = 0

var attacks = ["Shooting","Beam","Summon"]

var screenPositions = [Vector2(0,500),Vector2(0,200),Vector2(0,650)]

func setCombat(val):
	inCombat = val

func _ready() -> void:
	$AttackTimer.wait_time = PlayerStatManager.getBeatTime()

func subtractHealth(dmg : float):
	if health - dmg <= 0:
		print("dead")
	else:
		health = health - dmg

func beamAttack():
	if beamReady:
		print("Shooting")
		var beamAttackItem = beamAttackParticle.instantiate()
		beamAttackItem.global_position = screenPositions.pick_random()
		#beamAttackItem.get_child(0).emitting = true
		get_parent().add_child(beamAttackItem)
	else:
		beamReady = true


func _process(delta: float) -> void:
	pass

func _on_attack_timer_timeout() -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player Projectiles"):
		subtractHealth(PlayerStatManager.getDamage())
		body.queue_free()


func _on_beat_timer_timeout() -> void:
	if (inCombat):
		beats = beats + 1
		if beats >= 8:
			beamAttack()
			beats = 0
