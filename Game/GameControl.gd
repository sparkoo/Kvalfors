extends Node

var level = "res://Levels/LevelEndless.tscn"
var levelDifficulty = 8


func _on_Exit_pressed():
	get_tree().quit()


func startGame():
	print("start")
	randomize()
	get_tree().change_scene(level)


func _on_TryAgain_pressed():
	get_tree().reload_current_scene()


func updateDifficultyTo(newDifficulty: int):
	setDifficulty(newDifficulty)

func updateDifficultyBy(step: int):
	setDifficulty(levelDifficulty + step)

func setDifficulty(newValue: int):
	if newValue < 0:
		levelDifficulty = 0
	elif newValue > 8:
		levelDifficulty = 8
	else:
		levelDifficulty = newValue
