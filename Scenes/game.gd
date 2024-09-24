extends Node2D

@export var tempo : int = 120

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$BeatTimer.wait_time = 60 / tempo


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$BeatTimerLabel.text = "%s" % $BeatTimer.time_left
	if ($BeatTimer.time_left <= .4):
		$ResultLabel.show()
		$HitLabel.show()
	else:
		$ResultLabel.hide()
		$HitLabel.hide()
		
		

func _on_beat_t_imer_timeout():
	print_debug("Timer timeout")
