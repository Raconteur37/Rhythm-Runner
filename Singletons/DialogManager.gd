extends Node

@onready var text_box_scene = preload("res://Scenes/text_box.tscn")
@onready var game_scene = preload("res://Scenes/game.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0

var text_box
var text_box_position: Vector2

var character : String

var speechEvent: String

var is_dialog_active = false
var can_advance_line = false

func start_dialog(position: Vector2, lines: Array[String], characterSpeeking: String, aspeechEvent: String):
	if is_dialog_active:
		return
		
	dialog_lines = lines
	text_box_position = position
	character = characterSpeeking
	speechEvent = aspeechEvent
	_show_text_box()
	
	is_dialog_active = true
	
func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index],character)
	get_parent().add_child(text_box)
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true

func closeDialog():
	if is_dialog_active:
		text_box.queue_free()
		is_dialog_active = false
		current_line_index = 0
	

func _unhandled_input(event: InputEvent) -> void:
	#if (event.is_action_pressed("ui_a")):
	#	print("pressed")
	#	print(is_dialog_active)
	#	print(can_advance_line)
	if (
		event.is_action_pressed("ui_space") &&
		is_dialog_active &&
		can_advance_line
	):
		text_box.queue_free()
		
		current_line_index += 1
		
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			if (speechEvent == "shop_intro"):
				get_tree().root.get_child(2).find_child("ShopControl").startShop()
			if (speechEvent == "Intro"):
				get_tree().root.get_child(2).find_child("AnimationPlayer").play("FadeOut")
			return
		
		_show_text_box()
		
			
		
