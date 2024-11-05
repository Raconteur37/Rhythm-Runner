extends AudioStreamPlayer2D


func playAudio(audio):
	stream = load(audio)
	play()
	
func playStunAudio():
	stream = load("res://Sounds/FX/StunSound.mp3")
	play()

func playDashReadyAudio():
	stream = load("res://Sounds/FX/DashReady.mp3")
	play()
