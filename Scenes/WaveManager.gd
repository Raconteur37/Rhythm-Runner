extends Node2D

@export var currentFloor : int = 1
@export var currentWave : int = 1

@export var spawnTime : float = 1

var enemyMap = {}
var inWave = false # Test if the player is fighting in a wave
var enemiesAlive = []

func removeAliveEnemyFromList(enemy : CharacterBody2D):
	if (enemiesAlive.find(enemy) >= 0):
		enemiesAlive.remove_at(enemiesAlive.find(enemy))

func fillMap(floor : int, wave : int):
	
	if (floor == 1):
		match wave:
			1:
				enemyMap = {"AcidPuddle" : 1, "CoolLizard" : 1}
			2:
				enemyMap = {"AcidPuddle" : 15, "CoolLizard" : 6}
			
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

func generateRandomObsticlePosition():
	var aPosition = Vector2(randf_range(-20,1300),randf_range(85,500))
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
	fillMap(floor,wave)
	inWave = true
	$EnemySpawnTimer.wait_time = spawnTime
	
func _ready():
	startWave(currentFloor,currentWave)

func _on_enemy_spawn_timer_timeout():
	if (enemyMap.size() > 0):
		spawnEnemiesFromMap(1)
		
func _process(delta: float) -> void:
	if (enemyMap.is_empty() and enemiesAlive.is_empty() and inWave):
		inWave = false
		$"../AudioStreamPlayer2D".pitch_scale = .7
		$"../Player".global_position = $"../ShopControl/CanvasLayer/PlayerPosition".global_position
		$"../ShopControl/CanvasLayer".visible = true
		$"../ShopAnimationPlayer".play("ShopAppear")
		$"../ShopAnimationPlayer".emit_signal("animation_finished")
		print("Wave finished")
