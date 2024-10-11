extends CanvasLayer


const conductorLine1: Array[String] = [
	"Melody.....",
	"The world has gone silent",
	"You are the most capable..",
	"Please",
	"Bring us back into harmony."
]

var startedDialog = false

func _ready() -> void:
	$"../AnimationPlayer".play("BackgroundAnimation")
	$"../Music".play()
	
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not startedDialog:
		DialogManager.start_dialog($ConductorLocation.global_position,conductorLine1,"Conductor","Intro")
		startedDialog = true
	if (anim_name == "BackgroundAnimation"):
		$"../AnimationPlayer".play("BackgroundAnimationReverse")
	if (anim_name == "BackgroundAnimationReverse"):
		$"../AnimationPlayer".play("BackgroundAnimation")
