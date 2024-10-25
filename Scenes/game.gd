extends Node2D

@export var tempo : float = 120
var beatTime : float
var count : int = 0
var lenientTime 

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShopControl/CanvasLayer.visible = false
	await get_tree().create_timer(2).timeout
	$BeatTimer.wait_time = float(60) / tempo
	beatTime = float(60) / tempo
	PlayerStatManager.setBeatTime(beatTime)
	$AudioStreamPlayer2D.play()
	$BeatTimer.start(0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_beat_t_imer_timeout():
	$Label.show()
	if PlayerStatManager.getBeatTime() < .35:
		lenientTime = PlayerStatManager.getBeatTime() * .7
	else:
		lenientTime = PlayerStatManager.getBeatTime() * .5
	PlayerStatManager.setCanHit(true)
	await get_tree().create_timer(lenientTime).timeout
	PlayerStatManager.setCanHit(false)
	$Label.hide()
	pass

func _on_audio_stream_player_2d_finished() -> void:
	$AudioStreamPlayer2D.play()
	$BeatTimer.start(0)
