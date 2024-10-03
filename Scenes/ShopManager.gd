extends Control

@onready var speech_sound = preload("res://Sounds/conductorVoice.mp3")
@onready var commonItemExplosion = preload("res://Particles/common_item_summon_explosion.tscn")

const introLines: Array[String] = [
	"Hello my child.",
	"I offer you a choice of items...please choose one."
]


func _on_shop_animation_player_animation_finished(anim_name: StringName) -> void:
	DialogManager.start_dialog($CanvasLayer/TextBoxPosition.global_position,introLines,speech_sound,"shop_intro")


func startShop():
	
	var itemSound : AudioStreamPlayer2D = $ItemPickupAudio
	
	# Common 70%
	# Rare 20%
	# Super Rare 9%
	# Unseen 1%	
	var rarity = randi_range(1,100)
	var rarityString : String
	rarity = 91
	if rarity <= 70:
		$CanvasLayer/HBoxContainer3/Item1.texture_normal = load("res://Sprites/Items/commonItemFrame.png")
		$CanvasLayer/HBoxContainer3/Item2.texture_normal = load("res://Sprites/Items/commonItemFrame.png")
		$CanvasLayer/HBoxContainer3/Item3.texture_normal = load("res://Sprites/Items/commonItemFrame.png")
		itemSound.pitch_scale = 1
		rarityString = "Common"
	if rarity > 70 and rarity <= 90:
		$CanvasLayer/HBoxContainer3/Item1.texture_normal = load("res://Sprites/Items/rareItemFrame.png")
		$CanvasLayer/HBoxContainer3/Item2.texture_normal = load("res://Sprites/Items/rareItemFrame.png")
		$CanvasLayer/HBoxContainer3/Item3.texture_normal = load("res://Sprites/Items/rareItemFrame.png")
		itemSound.pitch_scale = 2
		rarityString = "Rare"
	if rarity > 90 and rarity <= 99:
		$CanvasLayer/HBoxContainer3/Item1.texture_normal = load("res://Sprites/Items/superRareItemFrame.png")
		$CanvasLayer/HBoxContainer3/Item2.texture_normal = load("res://Sprites/Items/superRareItemFrame.png")
		$CanvasLayer/HBoxContainer3/Item3.texture_normal = load("res://Sprites/Items/superRareItemFrame.png")
		itemSound.pitch_scale = 3
		rarityString = "Super Rare"
	if rarity == 100:
		$CanvasLayer/HBoxContainer3/Item1.texture_normal = load("res://Sprites/Items/UnseenItemFrame.png")
		$CanvasLayer/HBoxContainer3/Item2.texture_normal = load("res://Sprites/Items/UnseenItemFrame.png")
		$CanvasLayer/HBoxContainer3/Item3.texture_normal = load("res://Sprites/Items/UnseenItemFrame.png")
		itemSound.pitch_scale = 4
		rarityString = "Unseen"
	print(rarity)
	
	#Roll the rarities
	var explosion = commonItemExplosion.instantiate()
	if rarityString == "Rare":
		explosion.process_material.color = Color(0,255,0)
	if rarityString == "Super Rare":
		explosion.process_material.color = Color(71,0,255)
	if rarityString == "Unseen":
		explosion.process_material.color = Color(255,0,0)
	$CanvasLayer/HBoxContainer3/Item1.show()
	explosion.global_position = $Position1.global_position
	explosion.emitting = true
	explosion.one_shot = true
	get_tree().current_scene.find_child("CanvasLayer").add_child(explosion)
	itemSound.play()
	await get_tree().create_timer(1).timeout
	explosion.queue_free()
	explosion = commonItemExplosion.instantiate()
	if rarityString == "Rare":
		explosion.process_material.color = Color(0,255,0)
	if rarityString == "Super Rare":
		explosion.process_material.color = Color(71,0,255)
	if rarityString == "Unseen":
		explosion.process_material.color = Color(255,0,0)
	$CanvasLayer/HBoxContainer3/Item2.show()
	explosion.global_position = $Position2.global_position
	explosion.emitting = true
	explosion.one_shot = true
	get_tree().current_scene.find_child("CanvasLayer").add_child(explosion)
	itemSound.play()
	await get_tree().create_timer(1).timeout
	explosion.queue_free()
	explosion = commonItemExplosion.instantiate()
	if rarityString == "Rare":
		explosion.process_material.color = Color(0,255,0)
	if rarityString == "Super Rare":
		explosion.process_material.color = Color(71,0,255)
	if rarityString == "Unseen":
		explosion.process_material.color = Color(255,0,0)
	$CanvasLayer/HBoxContainer3/Item3.show()
	explosion.global_position = $Postition3.global_position
	explosion.emitting = true
	explosion.one_shot = true
	get_tree().current_scene.find_child("CanvasLayer").add_child(explosion)
	itemSound.play()
	

	
