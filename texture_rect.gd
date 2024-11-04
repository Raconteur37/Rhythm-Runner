extends TextureRect

func changeLabelName(text):
	$Label.text = str(text)

func changeSceneName(text):
	$".".name = str(text)
