extends Node2D

var health : int = 3
var damage : float = 3
var speed : float = 500
var dashSpeed : float = 700
var dashCooldown : float = 5
var projectileSpeed : float = 500
var projectileRangeTime : float = .5
var isImmune : bool = false

var items = {}

func getPlayerPosition():
	return global_position

func getRangeTime():
	return projectileRangeTime
	
func getDamage():
	return damage

func getSpeed():
	return speed
	
func getProjectileSpeed():
	return projectileSpeed
	
func getHealth():
	return health
	
func getDashSpeed():
	return dashSpeed
	
func getDashCooldown():
	return dashCooldown
	
func isPlayerImmune():
	return isImmune
	
func setPlayerImmune(immune):
	isImmune = immune
	
func setHealth(healthChange : int):
	health = healthChange
	
func addItem(item : String):
	if items.find_key(item):
		items[item] = items.get(item) + 1
	else:
		items[item] = 1
		
func scanItems():
	var amount : int
	
	for x in items.keys():
		match x:
			
			"Mystic Feather":
				amount = items.get(x)
				speed = 500 + (amount * 100)
			
