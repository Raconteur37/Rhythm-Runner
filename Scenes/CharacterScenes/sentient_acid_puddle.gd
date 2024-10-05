extends CharacterBody2D

func onDeath():
	get_parent().removeAliveEnemyFromList($".")
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(.9).timeout
	queue_free()
	


func _physics_process(delta):
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		onDeath()
		body.queue_free()
