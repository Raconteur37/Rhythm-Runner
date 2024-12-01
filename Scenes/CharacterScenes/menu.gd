extends Control

func _ready() -> void:
	$AnimationPlayer.play("Intro")
	$MainMenuMusic.play()
	pass

func _on_StartButton_pressed() -> void:
	$ClickSound.play()
	$AnimationPlayer.play("Exit")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "Exit"):
		get_tree().change_scene_to_file("res://Scenes/GameIntroScene.tscn")
