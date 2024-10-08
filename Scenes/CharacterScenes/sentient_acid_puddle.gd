extends CharacterBody2D

var health = 2
var isDead = false

func onDeath():
	if not isDead:
		isDead = true
		PlayerStatManager.onKill($".")
		get_parent().removeAliveEnemyFromList($".")
		$AnimatedSprite2D.play("death")
		await get_tree().create_timer(.9).timeout
		queue_free()
	
func takeDamage(damageAmount):
	health = health - damageAmount
	if health <= 0:
		onDeath()

func _physics_process(delta):
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player Projectiles"):
		body.queue_free()
		onDeath()
	if body.is_in_group("Enemy Projectiles"):
		body.queue_free()
