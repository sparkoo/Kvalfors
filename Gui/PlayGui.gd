extends Control

func playerDistanceUpdate(distance):
	$VBoxContainer/Distance.text = "%s m" % int(distance)

func setRecord(record):
	$VBoxContainer/Record.text = "Record: %s" % record

func difficultyUpdate(difficulty):
	$Difficulty.text = "Difficulty: %s" % difficulty
