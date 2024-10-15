extends Node2D

@export var tempo : float = 120
var beatTime : float
var count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$BeatTimer.wait_time = float(60) / tempo
	beatTime = float(60) / tempo
	PlayerStatManager.setBeatTime(beatTime)
	$ShopControl/CanvasLayer.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_beat_t_imer_timeout():
	#print($BeatTimer.wait_time)
	#count = count + 1
	#print(count)
	pass

func _on_audio_stream_player_2d_finished() -> void:
	$AudioStreamPlayer2D.play()
	$BeatTimer.start(0)
