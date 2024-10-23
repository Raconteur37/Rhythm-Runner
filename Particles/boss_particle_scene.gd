extends RayCast2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and $CPUParticles2D.emitting:
		body.wasHit()
