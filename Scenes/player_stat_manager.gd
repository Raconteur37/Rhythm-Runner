extends Node2D

var health : int = 3
var projectileRangeTime : float = .5


func getPlayerPosition():
	return global_position

func getRangeTime():
	return projectileRangeTime
	
