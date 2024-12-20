extends Camera2D

@export var decay : float = 1
@export var max_offset : Vector2 = Vector2(100,75)
@export var max_roll : float = .01 
@export var follow_node : Node2D

@onready var waveManager = $"../WaveManager"
var trauma : float = 0.0
var trauma_power : int = 2

func _ready():
	randomize()

func _process(delta: float) -> void:
	if (PlayerStatManager.getInWave()):
		if follow_node:
			global_position = follow_node.global_position
			
		if trauma:
			trauma = max(trauma - decay * delta, 0)
			beatShake()

func add_trauma(amount : float) -> void:
	trauma = min(trauma + amount, 1.0)

func beatShake() -> void:
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1,1)
	offset.x = max_offset.x * amount * randf_range(-1,1)
	offset.y = max_offset.y * amount * randf_range(-1,1)


func _on_beat_timer_timeout() -> void:
	add_trauma(.2)
