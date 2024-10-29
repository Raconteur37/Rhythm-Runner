extends Node2D

@onready var popcornExplosionParticle = preload("res://Particles/pop-corn particle.tscn")

var canHit : bool = false
var inWave : bool = false
var beatTime : float

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
var extraProjectileChance : float = 0
var blockChance : float = 0
var healthPotionGainChance : float = 0
var popcornChance : float = 0
const popcornBaseDamage : float = 20
var popcornDamage : float = popcornBaseDamage
const baseWandActivationShot : int = 6
var wandActivationShot : int = baseWandActivationShot
var shotNumber : int = 0
var hasWandVar = false
var isImmune : bool = false

var playerStatsString = ""

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

func getExtraProjectileChance():
	return extraProjectileChance
	
func getBlockChance():
	return blockChance
	
func getHealthPotionGainChance():
	return healthPotionGainChance
	
func getPopcornChance():
	return popcornChance
	
func getPopcornDamage():
	return popcornDamage
	
func getShotNumber():
	return shotNumber
	
func getShotActivationNumber():
	return wandActivationShot

func getCanHit():
	return canHit
	
func getInWave():
	return inWave
	
func getBeatTime():
	return beatTime

func setBeatTime(val):
	beatTime = val

func addShot():
	shotNumber = shotNumber + 1
	
func resetShot():
	shotNumber = 0
	
func isPlayerImmune():
	return isImmune
	
func hasWand():
	return hasWandVar
	
func setPlayerImmune(immune):
	isImmune = immune
	
func setHealth(healthChange : int):
	health = healthChange

func setCanHit(canHitVal):
	canHit = canHitVal

func setInWave(val):
	inWave = val

func takeDamage():
	health = health - 1

func onKill(enemy):
	var randNum = randf_range(1,101)
	if (randNum <= healthPotionGainChance):
		health = health + 1
	randNum = randf_range(1,101)
	if (randNum <= popcornChance):
		popcornExplosion(enemy.global_position)
	

func toString():
	var classString = """
	Health - {health}
	Damage - {damage}
	Speed - {speed}
	Dash Speed - {dashspeed}
	Dash Cooldown - {dashcooldown} Seconds
	Projectile Speed - {projectilespeed}
	Projectile Range - {projectilerange}
	Extra Projectile Chance - {extraprojectilechance}%
	Block Chance - {blockchance}%
	Health Potion Gain Chance - {healthpotiongainchance}%
	Pop-Corn Explosion Chance - {popcornchance}%
	Pop-Corn Explosion Damage - {popcorndamage}
	Conductor's Wand Activated - {wandactive}
	Conductor's Wand Activation Shot - {wandshot}
	""".format({"damage": damage, "health": health, "speed": speed, "dashspeed": dashSpeed, 
	"dashcooldown": dashCooldown, "projectilespeed": projectileSpeed, "projectilerange": projectileRangeTime, 
	"extraprojectilechance": extraProjectileChance,"blockchance": blockChance,
	 "healthpotiongainchance": healthPotionGainChance, "popcornchance": popcornChance, "popcorndamage": popcornDamage,
	"wandactive": hasWandVar, "wandshot": wandActivationShot})
	return classString

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
			extraProjectileChance = (amount * 6)
		"Metal Sheet":
			amount = items.get(item)
			blockChance = (amount * 7)
		"Medkit":
			amount = items.get(item)
			healthPotionGainChance = (amount * .5)
			
		"Pop-Corn":
			amount = items.get(item)
			popcornChance = (amount * 10)
			popcornDamage = popcornBaseDamage + (amount * 5)
			
		"Conductor's Baton":
			amount = items.get(item)
			hasWandVar = true
			wandActivationShot = baseWandActivationShot - (amount * 1)

func popcornExplosion(location : Vector2):
	var explosionParticle = popcornExplosionParticle.instantiate()
	explosionParticle.global_position = location
	explosionParticle.emitting = true
	explosionParticle.one_shot = true
	get_tree().root.add_child(explosionParticle)
	await get_tree().create_timer(1).timeout
	explosionParticle.queue_free()
