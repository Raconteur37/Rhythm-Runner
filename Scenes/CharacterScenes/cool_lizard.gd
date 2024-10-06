extends CharacterBody2D

var health = 10

@onready var projectile = preload("res://Scenes/Projectiles/lizard_enemy_projectile.tscn")

func _physics_process(delta: float) -> void:
	pass
	
func takeDamage(damageAmount : float):
	health = health - damageAmount
	

func onDeath():
	get_parent().removeAliveEnemyFromList($".")
	queue_free()


func _on_attack_timer_timeout() -> void:
	var proj = projectile.instantiate()
	proj.position = position
	proj.name = "LizardEnemyBullet"
	proj.linear_velocity = (get_parent().get_parent().find_child("Player").global_position - position).normalized()  * 600
	get_parent().add_child(proj)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		onDeath()
		body.queue_free()
		
