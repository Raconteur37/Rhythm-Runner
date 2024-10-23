extends Node2D

@export var currentFloor : int = 1
@export var currentWave : int = 1

@export var spawnTime : float = 1

var isInShop : bool = false

var bossFight : bool = false

var enemyMap = {}
var inWave = false # Test if the player is fighting in a wave
var enemiesAlive = []

func removeAliveEnemyFromList(enemy : CharacterBody2D):
	if (enemiesAlive.find(enemy) >= 0):
		enemiesAlive.remove_at(enemiesAlive.find(enemy))

func fillEnemyMap(floor : int, wave : int):
	
	if (floor == 1):
		match wave:
			1:
				enemyMap = {"AcidPuddle" : 5, "CoolLizard" : 5, "Bouncer" : 2}
			2:
				enemyMap = {"AcidPuddle" : 5, "CoolLizard" : 5, "Bouncer" : 5}
			3:
				enemyMap = {"AcidPuddle" : 20, "CoolLizard" : 15, "Bouncer" : 10}
			4:
				enemyMap = {"AcidPuddle" : 20, "CoolLizard" : 20}
			5:
				enemyMap = {"AcidPuddle" : 25, "CoolLizard" : 25}
func spawnEnemiesFromMap(amount : int):
	for n in range(amount):
		if enemyMap.size() > 0:
			var keys = enemyMap.keys()
			var enemyName = keys[randi() % keys.size()]
			instanceEnemyType(enemyName)
			if (enemyMap.get(enemyName) - 1 <= 0):
				enemyMap.erase(enemyName)
			else:
				enemyMap[enemyName] = enemyMap.get(enemyName) - 1

func instanceEnemyType(enemyName : String):
	match enemyName:
		
		"AcidPuddle":
			var enemy = preload("res://Scenes/CharacterScenes/sentient_acid_puddle.tscn")
			enemy = enemy.instantiate()
			enemiesAlive.append(enemy)
			enemy.position = generateRandomObsticlePosition()
			add_child(enemy)
		"CoolLizard":
			var enemy = preload("res://Scenes/CharacterScenes/cool_lizard.tscn")
			enemy = enemy.instantiate()
			enemiesAlive.append(enemy)
			enemy.position = generateRandomObsticlePosition()
			add_child(enemy)
		"Bouncer":
			var enemy = preload("res://Scenes/CharacterScenes/bouncer_enemy.tscn")
			enemy = enemy.instantiate()
			enemiesAlive.append(enemy)
			enemy.position = generateRandomObsticlePosition()
			add_child(enemy)


func generateRandomObsticlePosition():
	var aPosition = Vector2(randf_range(0,1700),randf_range(85,500))
	return aPosition
	
func getClosestEnemyFromSprite(sprite : CharacterBody2D):
	var distance = 999999
	var enemy = null
	for x in enemiesAlive:
		if (is_instance_valid(x)):
			if (sprite.global_position.distance_to(x.global_position) < distance):
				distance = sprite.global_position.distance_to(x.global_position)
				enemy = x
	if (enemy == null):
		print("No enemies around")
		return 0
	else:
		return enemy
		
func startWave(floor : int, wave : int):
	fillEnemyMap(floor,wave)
	inWave = true
	$EnemySpawnTimer.wait_time = spawnTime
	
	
func _ready():
	#startWave(currentFloor,currentWave)
	startBossOne()

func _on_enemy_spawn_timer_timeout():
	if (enemyMap.size() > 0):
		spawnEnemiesFromMap(1)
		
func _process(delta: float) -> void:
	if (enemyMap.is_empty() and enemiesAlive.is_empty() and inWave and !isInShop and !bossFight):
		inWave = false
		currentWave = currentWave + 1
		$"../ShopControl".audioResume = int($"../AudioStreamPlayer2D".get_playback_position()) + $"../BeatTimer".wait_time
		$"../BeatTimer".stop()
		$"../AudioStreamPlayer2D".stop()
		$"../ShopControl/ShopMusic".play()
		$"../Player".global_position = $"../ShopControl/CanvasLayer/PlayerPosition".global_position
		$"../ShopControl/CanvasLayer".visible = true
		$"../ShopAnimationPlayer".play("ShopAppear")
		$"../ShopAnimationPlayer".emit_signal("animation_finished")


func _on_audio_stream_player_2d_finished() -> void:
	$"../AudioStreamPlayer2D".play()
	

const bossOneLines: Array[String] = [
	"You've gotten his attention.",
	"The lobby manager is coming..."
]

const bossSpeaking: Array[String] = [
	"You've been a real pain.",
	"Making my lobby more filthy every second you're here.",
	"Die."
]

func startBossOne():
	$"../AudioStreamPlayer2D".stop()
	DialogManager.start_dialog($"../Player".global_position,bossOneLines,"Conductor","BossOne")
	
func startBossOneFight():
	$"../BossOneSong".stop()
	$"../BossOneSong".play()
	$"../FloorOneBoss".setCombat(true)
	bossFight = true
	inWave = true
	enemiesAlive.append($"../FloorOneBoss")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "BossOneAppear"):
		# Change Tempo
		PlayerStatManager.setBeatTime(float(60) / 175)
		$"../BossOneSong".play()
		DialogManager.start_dialog($"../Player".global_position,bossSpeaking,"BossOne","BossOneStart")
