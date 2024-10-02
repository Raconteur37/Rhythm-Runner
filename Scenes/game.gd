extends Node2D

@export var tempo : float = 120
var beatTime : float

# Called when the node enters the scene tree for the first time.
func _ready():
	$BeatTimer.wait_time = float(60) / tempo
	beatTime = float(60) / tempo
	$ShopControl/CanvasLayer.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_beat_t_imer_timeout():
	pass
