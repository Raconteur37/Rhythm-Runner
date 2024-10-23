extends CharacterBody2D

var beamAttack = preload("res://Particles/bossParticleScene.tscn")

var health : int = 1000
var inCombat : bool = false
var beamReady : bool = false
var shooting : bool = false
var beats : int = 0

var attacks = ["Shooting","Beam","Summon"]

func _ready() -> void:
	$AttackTimer.wait_time = PlayerStatManager.getBeatTime()

func subtractHealth(dmg : float):
	if health - dmg <= 0:
		print("dead")
	else:
		health = health - dmg


func _on_attack_timer_timeout() -> void:
	if (inCombat):
		beats = beats + 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player Projectiles"):
		subtractHealth(PlayerStatManager.getDamage())
		body.queue_free()
