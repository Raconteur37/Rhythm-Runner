extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShopControl/CanvasLayer.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_audio_stream_player_2d_finished() -> void:
	$Music.play()
	$Player.setBeatTimer(128)
