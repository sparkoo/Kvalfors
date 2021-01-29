extends Node

const HS_DISTANCE = "distance"
const HS_LEVEL = "endless"

var level = "res://Levels/LevelEndless.tscn"
var levelDifficulty = 8

var config = {
	"level": level,
	"levelDifficulty": levelDifficulty
}

var highScores = {
	HS_LEVEL: {
		0: {
			HS_DISTANCE: 0
		},
		1: {
			HS_DISTANCE: 0
		},
		2: {
			HS_DISTANCE: 0
		},
		3: {
			HS_DISTANCE: 0
		},
		4: {
			HS_DISTANCE: 0
		},
		5: {
			HS_DISTANCE: 0
		},
		6: {
			HS_DISTANCE: 0
		},
		7: {
			HS_DISTANCE: 0
		},
		8: {
			HS_DISTANCE: 0
		}
	}
}

func _ready():
	loadConfig()
	loadHighScores()

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

func loadHighScores():
	var loaded = Utils.loadDictionary("user://highScores.json")
	if loaded != null:
		highScores = loaded

func isNewRecord(score: int):
	return score > highScores[HS_LEVEL][levelDifficulty][HS_DISTANCE]

func saveHighScore(newScore: int):
	var currentScore = highScores[HS_LEVEL][levelDifficulty][HS_DISTANCE]
	if isNewRecord(newScore):
		highScores[HS_LEVEL][levelDifficulty][HS_DISTANCE] = newScore
		Utils.save("user://highScores.json", highScores)

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

func getHighScore() -> int:
	if highScores.has(HS_LEVEL):
		if highScores[HS_LEVEL].has(levelDifficulty):
			if highScores[HS_LEVEL][levelDifficulty].has(HS_DISTANCE):
				return highScores[HS_LEVEL][levelDifficulty][HS_DISTANCE]
	
	return 0
