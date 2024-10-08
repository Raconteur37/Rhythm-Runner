extends Node2D

var current_level = 1  # Tracks which level Melody is on

# List of positions for each level (bottom to top)
var level_positions = [
	Vector2(500, 400),  # Level 1 - Bottom Center
	Vector2(400, 300), Vector2(600, 300),  # Level 2 - Left and Right
	Vector2(300, 200), Vector2(500, 200), Vector2(700, 200),  # Level 3
	Vector2(200, 100), Vector2(400, 100), Vector2(600, 100), Vector2(800, 100)  # Level 4 (Example)
]

# Function to trigger the transition to the next level
func transition_to_next_level():
	if current_level <= 5:  # Assuming there are 5 levels
		print("Transitioning to level", current_level)  # Print to the console
		
		# Set the position of Melody to the next level's position
		$Sprite2D.position = level_positions[current_level - 1] 
		
		# Play the animation for moving to the next level
		$AnimationPlayer.play("move_to_the_next_level")
		
		# Move to the next level
		current_level += 1

# Function that gets called when the level is completed
func on_level_completed():
	print("Level", current_level, "completed! Transitioning to the next level.")  # Output message to the console
	transition_to_next_level()  # Trigger the transition to the next level

# Function to check for player input (pressing spacebar to complete a level)
func _input(event):
	if event.is_action_pressed("ui_accept"):  # "ui_accept" is the spacebar by default
		print("Spacebar pressed!")  # This should show in the console when spacebar is pressed
		on_level_completed()  # Simulate level completion when spacebar is pressed
