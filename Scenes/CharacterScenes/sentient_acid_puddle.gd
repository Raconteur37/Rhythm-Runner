extends CharacterBody2D

func onDeath():
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(.9).timeout
	queue_free()


func _physics_process(delta):
	pass
