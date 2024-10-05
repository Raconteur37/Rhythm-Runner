extends RigidBody2D

func _ready() -> void:
	$RangeTimer.wait_time = PlayerStatManager.getRangeTime()

func _on_range_timer_timeout() -> void:
	#Make these explode
	queue_free()
