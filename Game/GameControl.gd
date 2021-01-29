extends Node

var level = "res://Levels/LevelEndless.tscn"
var levelDifficulty = 8

var config = {
	"level": level,
	"levelDifficulty": levelDifficulty
}

func _ready():
	loadConfig()

func _on_Exit_pressed():
	exitGame()


func startGame():
	randomize()
	get_tree().change_scene(level)

func exitGame():
	get_tree().quit()

func saveConfig():
	Utils.save("user://config.json", config)

func loadConfig():
	config = Utils.loadDictionary("user://config.json")
	levelDifficulty = config.levelDifficulty
	setDifficulty(levelDifficulty)


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
		
	config.levelDifficulty = levelDifficulty
	saveConfig()
