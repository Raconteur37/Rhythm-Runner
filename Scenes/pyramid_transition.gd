extends Node2D

var current_level = 1  # Tracks which level Melody is on

# Function to trigger the transition to the next level
func transition_to_next_level():
	match current_level:
		1:
			$AnimationPlayer_Level1.play("move_to_level_1")
		2:
			$AnimationPlayer_Level2.play("move_to_level_2")
		3:
			$AnimationPlayer_Level3.play("move_to_level_3")
		4:
			$AnimationPlayer_Level4.play("move_to_level_4")
		5:
			$AnimationPlayer_Level5.play("move_to_level_end")

	# Move to the next level
	current_level += 1

# Function to check for player input (pressing spacebar to complete a level)
func _input(event):
	if event.is_action_pressed("ui_accept") and current_level <= 5:  # Allow spacebar press for levels 1-5
		print("Spacebar pressed! Transitioning to next level.")
		transition_to_next_level()  # Move to the next level when spacebar is pressed

# Handle animation completion for Level 1
func _on_AnimationPlayer_Level1_animation_finished():
	print("Finished level 1 transition.")
	# Unlock input or other logic after animation finishes

# Handle animation completion for Level 2
func _on_AnimationPlayer_Level2_animation_finished():
	print("Finished level 2 transition.")
	# Unlock input or other logic after animation finishes

# Handle animation completion for Level 3
func _on_AnimationPlayer_Level3_animation_finished():
	print("Finished level 3 transition.")
	# Unlock input or other logic after animation finishes

# Handle animation completion for Level 4
func _on_AnimationPlayer_Level4_animation_finished():
	print("Finished level 4 transition.")
	# Unlock input or other logic after animation finishes

# Handle animation completion for Level 5
func _on_AnimationPlayer_Level5_animation_finished():
	print("Finished level 5 transition.")
	print("All levels completed! Character exits the tower.")
	# Additional logic for completing the game
