extends CharacterBody2D

var health = 6
var isDead = false

@onready var projectile = preload("res://Scenes/Projectiles/lizard_enemy_projectile.tscn")

func _physics_process(delta: float) -> void:
	pass
	
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
		


func _on_attack_timer_timeout() -> void:
	var proj = projectile.instantiate()
	proj.position = position
	proj.name = "LizardEnemyBullet"
	proj.linear_velocity = (get_parent().get_parent().find_child("Player").global_position - position).normalized()  * 600
	get_parent().add_child(proj)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player Projectiles"):
		takeDamage(PlayerStatManager.getDamage())
		body.queue_free()
		
