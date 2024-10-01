extends CharacterBody2D

@onready var projectile = preload("res://Scenes/Projectiles/cool_lizard_projectile.tscn")

func _physics_process(delta: float) -> void:
	pass
	

func onDeath():
	queue_free()


func _on_attack_timer_timeout() -> void:
	var proj = projectile.instantiate()
	proj.position = position
	proj.target = get_parent().get_parent().find_child("Player")
	proj.varVelocity = (proj.target.position - position).normalized()
	get_parent().add_child(proj)
