extends Control

const introLines: Array[String] = [
	"Hello my child.",
	"I offer you a choice of items...please choose one."
]


func _on_shop_animation_player_animation_finished(anim_name: StringName) -> void:
	DialogManager.start_dialog($CanvasLayer/HBoxContainer/TextBoxPosition.global_position,introLines)
