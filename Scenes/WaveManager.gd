extends Node2D

@export var currentFloor : int = 1
@export var currentWave : int = 1

@export var spawnTime : float = 1

var enemyMap = {}

var enemiesAlive = []

func removeAliveEnemyFromList(enemy : CharacterBody2D):
	if (enemiesAlive.find(enemy) >= 0):
		enemiesAlive.remove_at(enemiesAlive.find(enemy))

func fillMap(floor : int, wave : int):
	
	if (floor == 1):
		match wave:
			1:
				enemyMap = {"AcidPuddle" : 20}
			
			
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
	
	
func _ready():
	fillMap(1,1)
	$EnemySpawnTimer.wait_time = spawnTime

func _on_enemy_spawn_timer_timeout():
	if (enemyMap.size() > 0):
		spawnEnemiesFromMap(1)
