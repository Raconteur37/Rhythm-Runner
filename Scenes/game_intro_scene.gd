extends CanvasLayer

var tutorialBass = preload("res://Sounds/Tutorial/tutorialBass.mp3")
var tutorialPhaseTwo = preload("res://Sounds/Tutorial/Tutorial Phase 2.mp3")
var tutorialSong = preload("res://Sounds/Tutorial/Tutorial Song.mp3")

var dummy = preload("res://Scenes/CharacterScenes/training_dummy.tscn")

var stepOneCompleted = false
var stepOneCheck = false

var stepTwoCompleted = false
var stepTwoCheck = false

var stepThreeCompleted = false
var stepThreeCheck = false

var stepFourCheck = false

var enemies = []

var beats = 0

const conductorLine1: Array[String] = [
	"Melody.....",
	"Wake up.",
	"The world has gone silent from Mute",
	"His record was leaked and now he wants revenge",
	"You need to go into the tower and defeat him",
	"But...",
	"Since you've been away for a while...",
	"Let's go over some basics before you head in there."
]

const tutorialLineOne: Array[String] = [
	"First, try to move around."
]

const tutorialLineTwo: Array[String] = [
	"Great job!",
	"Now practice a dash while moving."
]

const tutorialLineThree: Array[String] = [
	"Perfect",
	"Keep in mind a dash has a cooldown.",
	"Now you im going to give you a beat.",
	"Practice hitting the space key on beat."
]

const tutorialLineFour: Array[String] = [
	"Nice! You aren't tone deaf.",
	"Now im going to summon some dummies.",
	"Press space on beat to defeat them.",
	"Keep in mind you target the closest enemy to you."
]


const tutorialLineFive: Array[String] = [
	"Well done Melody",
	"Now head into the tower.",
	"There are 5 floors you'll need to push through.",
	"At the end of each floor will be a boss",
	"But do not worry...I'll be with you throughout your journey.",
	"Goodluck."
]

const test: Array[String] = [
	"balls"
]

var startedDialog = false

func removeFromList(sprite):
	enemies.remove_at(enemies.find(sprite))

func _ready() -> void:
	$"../AnimationPlayer".play("FadeIn")
	$"../Music".play()

func getClosestEnemyFromSprite(sprite : CharacterBody2D):
	var distance = 999999
	var enemy = null
	for x in enemies:
		if (is_instance_valid(x)):
			if (sprite.global_position.distance_to(x.global_position) < distance):
				distance = sprite.global_position.distance_to(x.global_position)
				enemy = x
	if (enemy == null):
		print("No enemies around")
		return 0
	else:
		return enemy

func tutorialStepOne():
	DialogManager.start_dialog($ConductorLocation.global_position,tutorialLineOne,"Conductor","")
	await get_tree().create_timer(3).timeout
	stepOneCheck = true
	$"../Player".tutorial = true
	
func tutorialStepTwo():
	DialogManager.start_dialog($ConductorLocation.global_position,tutorialLineTwo,"Conductor","")
	await get_tree().create_timer(5).timeout
	$HBoxContainer3/StepTwoLabel.show()
	stepTwoCheck = true
	
func tutorialStepThree():
	DialogManager.start_dialog($ConductorLocation.global_position,tutorialLineThree,"Conductor","")
	await get_tree().create_timer(10).timeout
	$HBoxContainer3/StepThreeLabel.show()
	$"../Music".stop()
	$"../TutorialSounds".stream = load("res://Sounds/Tutorial/Tutorial Phase 2.mp3")
	$"../TutorialSounds".play()
	stepThreeCheck = true
	$"../Player".tutorialShoot = true
	$"../Player".setBeatTimer(125)
	
func tutorialStepFour():
	DialogManager.start_dialog($ConductorLocation.global_position,tutorialLineFour,"Conductor","")
	await get_tree().create_timer(10).timeout
	$HBoxContainer3/StepFourLabel.show()
	$"../TutorialSounds".stream = load("res://Sounds/Tutorial/Tutorial Song.mp3")
	$"../TutorialSounds".play()
	$"../Player".setBeatTimer(125)
	var enemy = dummy.instantiate()
	enemies.append(enemy)
	enemy.position = Vector2(1755,365)
	add_child(enemy)
	enemy = dummy.instantiate()
	enemies.append(enemy)
	enemy.position = Vector2(1603,700)
	add_child(enemy)
	stepFourCheck = true
	
func finalStep():
	DialogManager.start_dialog($ConductorLocation.global_position,tutorialLineFive,"Conductor","TutorialEnd")
	
func _process(delta: float) -> void:
	
	#if $"../Player".canShoot:
	#	$"../ShootLabel".show()
	#else:
	#	$"../ShootLabel".hide()
	
	if (stepOneCheck):
		$HBoxContainer3/StepOneLabel.show()
		if Input.get_action_strength("ui_d"):
			stepOneCompleted = true
			stepOneCheck = false
		if Input.get_action_strength("ui_a"):
			stepOneCompleted = true
			stepOneCheck = false
		if Input.get_action_strength("ui_w"):
			stepOneCompleted = true
			stepOneCheck = false
		if Input.get_action_strength("ui_s"):
			stepOneCompleted = true
			stepOneCheck = false
			
	if (stepTwoCheck):
		if Input.get_action_strength("ui_dash"):
			stepTwoCheck = false
			stepTwoCompleted = true
	
	if stepThreeCheck:
		$HBoxContainer3/StepThreeLabel.text = str(beats) + "/10 BEATS HIT"
		if beats >= 10:
			stepThreeCheck = false
			stepThreeCompleted = true
			
	if stepFourCheck:
		if enemies.size() == 0:
			stepFourCheck = false
			$HBoxContainer3/StepFourLabel.label_settings = load("res://Labels/CompletedLabel.tres")
			$"../CorrectSound".play()
			await get_tree().create_timer(2).timeout
			finalStep()
			$HBoxContainer3/StepFourLabel.hide()
	
	if stepOneCompleted:
		stepOneCompleted = false
		DialogManager.closeDialog()
		$"../CorrectSound".play()
		$HBoxContainer3/StepOneLabel.label_settings = load("res://Labels/CompletedLabel.tres")
		await get_tree().create_timer(2).timeout
		$HBoxContainer3/StepOneLabel.hide()
		tutorialStepTwo()
	
	if stepTwoCompleted:
		stepTwoCompleted = false
		DialogManager.closeDialog()
		$"../CorrectSound".play()
		$HBoxContainer3/StepTwoLabel.label_settings = load("res://Labels/CompletedLabel.tres")
		await get_tree().create_timer(2).timeout
		$HBoxContainer3/StepTwoLabel.hide()
		tutorialStepThree()
		
	if stepThreeCompleted:
		stepThreeCompleted = false
		DialogManager.closeDialog()
		$"../CorrectSound".play()
		$HBoxContainer3/StepThreeLabel.label_settings = load("res://Labels/CompletedLabel.tres")
		await get_tree().create_timer(2).timeout
		$HBoxContainer3/StepThreeLabel.hide()
		tutorialStepFour()
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "FadeIn"):
		$"../AnimationPlayer".play("BackgroundAnimation")
	if (anim_name == "FadeOut"):
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	if not startedDialog:
		DialogManager.start_dialog($ConductorLocation.global_position,conductorLine1,"Conductor","Intro")
		startedDialog = true
	if (anim_name == "BackgroundAnimation"):
		$"../AnimationPlayer".play("BackgroundAnimationReverse")
	if (anim_name == "BackgroundAnimationReverse"):
		$"../AnimationPlayer".play("BackgroundAnimation")


func _on_music_finished() -> void:
	$"../Music".play()


func _on_tutorial_sounds_finished() -> void:
	$"../TutorialSounds".play()
	$"../Player".setBeatTimer(125)
