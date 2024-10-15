extends CharacterBody2D

var dash = false
var health = 6
var isDead = false

var directions = [Vector2(1,0),Vector2(0,1),Vector2(1,1),Vector2(-1,0),Vector2(0,-1)]

const SPEED = 500

func takeDamage(damageAmount):
	health = health - damageAmount
	if health <= 0:
		onDeath()

func onDeath():
	if (not isDead):
		get_parent().removeAliveEnemyFromList($".")
		PlayerStatManager.onKill($".")
		isDead = true
		queue_free()

func _physics_process(delta: float) -> void:
	if (dash):
		move_and_slide()

func pauseCooldown():
	await get_tree().create_timer(.3).timeout
	dash = false

func _on_attack_timer_timeout() -> void:
	dash = true
	velocity = directions.pick_random() * SPEED
	pauseCooldown()

func _ready() -> void:
	$AttackTimer.wait_time = PlayerStatManager.getBeatTime()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player Projectiles"):
		takeDamage(PlayerStatManager.getDamage())
		body.queue_free()
		
