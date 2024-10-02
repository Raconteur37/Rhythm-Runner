extends Control

func _ready() -> void:
	# This function is called when the node enters the scene tree
	pass

func _on_StartButton_pressed() -> void:
	# Change the scene to the next one using the correct method for Godot 4.x
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
