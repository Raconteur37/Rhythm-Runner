extends Node2D

var health : int = 3
const baseDamage : float = 3
var damage : float = baseDamage
const baseSpeed : float = 500
var speed : float = baseSpeed
const baseDashSpeed : float = 1000
var dashSpeed : float = baseDashSpeed
const baseDashCooldown : float = 5
var dashCooldown : float = baseDashCooldown
const baseProjectileSpeed : float = 500
var projectileSpeed : float = baseProjectileSpeed
const baseProjectileRangeTime : float = .5
var projectileRangeTime : float = baseProjectileRangeTime
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

		
func applyItem(item : String):
	
	if items.find_key(item):
		items[item] = items.get(item) + 1
	else:
		items[item] = 1
		
	var amount : int

	match item:
		
		"Mystic Feather":
			amount = items.get(item)
			speed = baseSpeed + (amount * 100)
		"Shiny Cape":
			amount = items.get(item)
			dashSpeed = baseDashSpeed + (amount * 300)
		"Bundle of Wires":
			amount = items.get(item)
			projectileSpeed = baseProjectileSpeed + (amount * 200)
			
		"Subwoofer":
			amount = items.get(item)
			
