extends Control

const lines: Array[String] = [
	"Hello!",
	"What would you like?",
	"Ah...very good choice, that item is very rare!",
	"However, there is a dark curse that comes along with it.",
]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_a"):
		DialogManager.start_dialog($CanvasLayer/HBoxContainer/TextBoxPosition.global_position,lines)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
