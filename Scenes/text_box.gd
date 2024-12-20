extends MarginContainer

@onready var timer = $CanvasLayer/LetterDisplayTimer
@onready var label = $CanvasLayer/MarginContainer/Label
@onready var audio_player = $CanvasLayer/ConductorVoice

const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_time = .03
var space_time = .06
var punctuation_time = .2

signal finished_displaying()

func display_text(displayText: String, speechChar: String):
	text = displayText
	#label.text = displayText
	if (speechChar == "Conductor"):
		audio_player = $CanvasLayer/ConductorVoice
	if (speechChar == "BossOne"):
		audio_player = $CanvasLayer/BossVoice
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
		
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	
	label.text = ""
	_display_letter()
	
func _display_letter():
	
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
		
	match text[letter_index]:
		"!",".",",","?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time) 
			
			var new_audio_player = audio_player.duplicate()
			new_audio_player.pitch_scale += randf_range(-0.1,0.1)
			if text[letter_index] in ["a","e","i","o","u"]:
				new_audio_player.pitch_scale += 0.2
			get_tree().root.add_child(new_audio_player)
			new_audio_player.play()
			await new_audio_player.finished
			new_audio_player.queue_free()


func _on_letter_display_timer_timeout() -> void:
	_display_letter()
