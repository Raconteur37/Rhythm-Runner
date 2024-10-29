extends CharacterBody2D

var health = 10
var isDead = false

func takeDamage(damageAmount):
	health = health - damageAmount
	$AnimationPlayer.play("onHit")
	if health <= 0:
		onDeath()

func onDeath():
	if (not isDead):
		get_parent().removeFromList($".")
		isDead = true
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player Projectiles"):
		takeDamage(PlayerStatManager.getDamage())
		body.queue_free()
