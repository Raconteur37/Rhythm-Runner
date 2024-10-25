extends Control

@onready var commonItemExplosion = preload("res://Particles/common_item_summon_explosion.tscn")

const commonItems : Array[String] = ["Mystic Feather","Shiny Cape","Bundle of Wires"]
const rareItems : Array[String] = ["Subwoofer","Medkit","Metal Sheet"]
const superRareItems : Array[String] = ["Pop-Corn"]
const unseenItems : Array[String] = ["Conductor's Baton"]

var button1Pressed : bool = false
var button2Pressed : bool = false
var button3Pressed : bool = false

var selectedItem : String

var audioResume

var currentItemsListed : Array[String] = []

const introLines: Array[String] = [
	"I offer you a choice of items...please choose one."
]
const outroLines: Array[String] = [
	"Good choice!"
]


func _on_shop_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "ShopAppear"):
		DialogManager.start_dialog($CanvasLayer/HBoxContainer/TextBoxPosition.global_position,introLines,"Conductor","shop_intro")
		DialogManager.start_dialog($CanvasLayer/HBoxContainer/TextBoxPosition.global_position,introLines,"Conductor","shop_intro")

func getItemDialog(itemName : String):
	
	var words : Array[String] = ["Test","Testing"]
	
	match itemName:
		
		#Common
		"Mystic Feather":
			words = ["Ah, the Mystic Feather","This item will increase your movement speed"]
			return words
		"Shiny Cape":
			words = ["An extention of your cape","This will increase how far you can dash"]
			return words
		"Bundle of Wires":
			words = ["A Bundle of Wires!","Use these to increase the speed of your projectiles"]
			return words

	
		#Rare
		"Subwoofer":
			words = ["The Subwoofer...","When you shoot, you might shoot some extra projectiles"]
			return words
		"Medkit":
			words = ["The classic Medkit","Killing an enemy has a chance to gift you a health potion"]
			return words
		"Metal Sheet":
			words = ["A sturdy Metal Sheet?","This might take a hit for you"]
			return words
	
		#Super Rare
		"Pop-Corn":
			words = ["Pop-Corn...hehe","Get it....","Anyway, when you kill an enemy they will probably explode"]
			return words
			
		#Unseen
		"Conductor's Baton":
			words = ["What????","Is that my baton!","Well if you want it..."]
			return words
	
func pickItem(itemRarity : String, itemNumber : int):
	var item : String
	if itemRarity == "Common":
		item = commonItems.pick_random()
	if itemRarity == "Rare":
		item = rareItems.pick_random()
	if itemRarity == "Super Rare":
		item = superRareItems.pick_random()
	if itemRarity == "Unseen":
		item = unseenItems.pick_random()
		
	if itemNumber == 1:
		$CanvasLayer/HBoxContainer3/Item1/Item1Sprite.texture = load(getItemImage(item))
		currentItemsListed.append(item)
	if itemNumber == 2:
		$CanvasLayer/HBoxContainer3/Item2/Item2Sprite.texture = load(getItemImage(item))
		currentItemsListed.append(item)
	if itemNumber == 3:
		$CanvasLayer/HBoxContainer3/Item3/Item3Sprite.texture = load(getItemImage(item))
		currentItemsListed.append(item)
	
func getItemImage(itemName : String):
	match itemName:
		
		#Common
		"Mystic Feather":
			return "res://Sprites/Items/CommonItems/MysticFeather.png"
		"Shiny Cape":
			return "res://Sprites/Items/CommonItems/Shiny Cape.png"
		"Bundle of Wires":
			return "res://Sprites/Items/CommonItems/Bundle of Wires.png"
			
		#Rare
		"Subwoofer":
			return "res://Sprites/Items/Rare Items/Subwoofer.png"
		"Medkit":
			return "res://Sprites/Items/Rare Items/Medkit.png"
		"Metal Sheet":
			return "res://Sprites/Items/Rare Items/Metal Sheet.png"
			
		#Super Rare
		"Pop-Corn":
			return "res://Sprites/Items/Super Rare Items/Pop-Corn.png"
			
		#Unseen
		"Conductor's Baton":
			return "res://Sprites/Items/Unseen Items/Conductor's Baton.png"

func startShop():
	$"../WaveManager".isInShop = true
	$CanvasLayer/HBoxContainer3/Item1.disabled = false
	$CanvasLayer/HBoxContainer3/Item2.disabled = false
	$CanvasLayer/HBoxContainer3/Item3.disabled = false
	button1Pressed = false
	button2Pressed = false
	button3Pressed = false
	currentItemsListed.clear()
	selectedItem = ""
	
	var itemSound : AudioStreamPlayer2D = $ItemPickupAudio
	
	# Common 70% 
	# Rare 20%
	# Super Rare 9%
	# Unseen 1%	
	var rarity = randi_range(1,100)
	var rarityString : String
	
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
	
	var explosion = commonItemExplosion.instantiate()
	
	if rarityString == "Common":
		explosion.process_material.color = Color(255,255,255)
	if rarityString == "Rare":
		explosion.process_material.color = Color(0,255,0)
	if rarityString == "Super Rare":
		explosion.process_material.color = Color(71,0,255)
	if rarityString == "Unseen":
		explosion.process_material.color = Color(255,0,0)
		
	$CanvasLayer/HBoxContainer3/Item1.show()
	pickItem(rarityString,1)
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
	pickItem(rarityString,2)
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
	pickItem(rarityString,3)
	explosion.global_position = $Postition3.global_position
	explosion.emitting = true
	explosion.one_shot = true
	get_tree().current_scene.find_child("CanvasLayer").add_child(explosion)
	itemSound.play()


func closeShop():
	$ShopMusic.stop()
	$"../AudioStreamPlayer2D".play(audioResume)
	print($"../AudioStreamPlayer2D".get_playback_position())
	$"../BeatTimer".start(0)
	DialogManager.closeDialog()
	DialogManager.start_dialog($CanvasLayer/HBoxContainer/TextBoxPosition.global_position,outroLines,"Conductor","")
	await get_tree().create_timer(4).timeout
	DialogManager.closeDialog()
	$"../ShopAnimationPlayer".play("ShopDisappear")
	$"../WaveManager".isInShop = false
	await get_tree().create_timer(2).timeout
	$"../AudioStreamPlayer2D".pitch_scale = 1
	$"../WaveManager".startWave($"../WaveManager".currentFloor,$"../WaveManager".currentWave)
	

func _on_item_1_pressed() -> void:
	print("Button 1 pressed")
	button2Pressed = false
	button3Pressed = false
	selectedItem = currentItemsListed[0]
	if (button1Pressed):
		PlayerStatManager.applyItem(selectedItem)
		$CanvasLayer/HBoxContainer3/Item2.disabled = true
		$CanvasLayer/HBoxContainer3/Item3.disabled = true
		$CanvasLayer/HBoxContainer3/Item1.hide()
		closeShop()
	else:
		DialogManager.closeDialog()
		button1Pressed = true
		DialogManager.start_dialog($CanvasLayer/HBoxContainer/TextBoxPosition.global_position,getItemDialog(selectedItem),"Conductor","shop_explanation")


func _on_item_2_pressed() -> void:
	print("Button 2 pressed")
	button1Pressed = false
	button3Pressed = false
	selectedItem = currentItemsListed[1]
	if (button2Pressed):
		PlayerStatManager.applyItem(selectedItem)
		$CanvasLayer/HBoxContainer3/Item3.disabled = true
		$CanvasLayer/HBoxContainer3/Item1.disabled = true
		$CanvasLayer/HBoxContainer3/Item2.hide()
		closeShop()
	else:
		DialogManager.closeDialog()
		button2Pressed = true
		DialogManager.start_dialog($CanvasLayer/HBoxContainer/TextBoxPosition.global_position,getItemDialog(selectedItem),"Conductor","shop_explanation")


func _on_item_3_pressed() -> void:
	print("Button 3 pressed")
	button1Pressed = false
	button2Pressed = false
	selectedItem = currentItemsListed[2]
	if (button3Pressed):
		PlayerStatManager.applyItem(selectedItem)
		$CanvasLayer/HBoxContainer3/Item1.disabled = true
		$CanvasLayer/HBoxContainer3/Item2.disabled = true
		$CanvasLayer/HBoxContainer3/Item3.hide()
		closeShop()
	else:
		DialogManager.closeDialog()
		button3Pressed = true
		DialogManager.start_dialog($CanvasLayer/HBoxContainer/TextBoxPosition.global_position,getItemDialog(selectedItem),"Conductor","shop_explanation")
