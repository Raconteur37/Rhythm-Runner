extends CanvasLayer


const conductorLine1: Array[String] = [
	"Melody.....",
	"The world has gone silent",
	"You are the most capable..",
	"Please",
	"Bring us back into harmony."
]

@onready var speech_sound = preload("res://Sounds/conductorVoice.mp3")

func _ready() -> void:
	$"../AnimationPlayer".play("BackgroundAnimation")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	DialogManager.start_dialog($ConductorLocation.global_position,conductorLine1,speech_sound,"Intro")
	print("made")
	if (anim_name == "BackgroundAnimation"):
		$"../AnimationPlayer".play("BackgroundAnimationReverse")
	if (anim_name == "BackgroundAnimationReverse"):
		$"../AnimationPlayer".play("BackgroundAnimation")
