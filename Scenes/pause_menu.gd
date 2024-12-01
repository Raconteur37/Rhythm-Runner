extends Control


func _on_label_visibility_changed() -> void:
	if $".".visible:
		$Label.text = PlayerStatManager.toString()


func _on_resume_pressed() -> void:
	get_tree().root.get_node("/root/Node2D").pauseMenuFunc()


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Sprites/menu.tscn")
