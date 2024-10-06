extends Node2D

var health : int = 3
var damage : float = 3
var speed : float = 500
var projectileSpeed : float = 500
var projectileRangeTime : float = .5
var isImmune : bool = false


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
	
func isPlayerImmune():
	return isImmune
	
func setPlayerImmune(immune):
	isImmune = immune
	
func setHealth(healthChange : int):
	health = healthChange
