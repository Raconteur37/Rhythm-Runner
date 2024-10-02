extends AnimatedSprite2D


func _on_beat_timer_timeout() -> void:
	$".".frame = 1
	#await get_tree().create_timer($"..".beatTime / float(2)).timeout
	await get_tree().create_timer(.5).timeout
	$".".frame = 0

func _process(delta: float) -> void:
	pass
