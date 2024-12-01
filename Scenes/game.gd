extends Node2D

@onready var pauseMenu = $ControlPlayerUI/PlayerUI/PauseMenu
var paused = false

var tempPlace
# Called when the node enters the scene tree for the first time.
func _ready():
	$ShopControl/CanvasLayer.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenuFunc()
		
func pauseMenuFunc():
	if paused:
		$Music.play(tempPlace)
		pauseMenu.hide()
		Engine.time_scale = 1
		paused = false
	else:
		tempPlace = $Music.get_playback_position( )
		$Music.stop()
		pauseMenu.show()
		Engine.time_scale = 0
		paused = true

func _on_audio_stream_player_2d_finished() -> void:
	$Music.play()
	$Player.setBeatTimer(128)
