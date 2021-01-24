extends Control

func playerDistanceUpdate(distance):
	$Distance.text = "%s m" % int(distance)

func difficultyUpdate(difficulty):
	$Difficulty.text = "Difficulty: %s" % difficulty
