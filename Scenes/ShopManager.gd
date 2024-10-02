extends Control

@onready var speech_sound = preload("res://Sounds/conductorVoice.mp3")

const introLines: Array[String] = [
	"Hello my child.",
	"I offer you a choice of items...please choose one."
]


func _on_shop_animation_player_animation_finished(anim_name: StringName) -> void:
	DialogManager.start_dialog($CanvasLayer/TextBoxPosition.global_position,introLines,speech_sound)
