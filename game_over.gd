extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Gameover Music".play()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	