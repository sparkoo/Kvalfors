extends Node

enum ControlTypes{CLASSIC, CENTRALIZED}

const HS_DISTANCE = "distance"
const HS_LEVEL = "endless"


var mainMenu = "res://Gui/MainMenu.tscn"
var level = "res://Levels/LevelEndless.tscn"
var levelDifficulty = 8
var controls = ControlTypes.CLASSIC

var config = {
	"level": level,
	"levelDifficulty": levelDifficulty,
	"controls": controls
}

var highScores = {
	HS_LEVEL: {
		"0": {
			HS_DISTANCE: 0
		},
		"1": {
			HS_DISTANCE: 0
		},
		"2": {
			HS_DISTANCE: 0
		},
		"3": {
			HS_DISTANCE: 0
		},
		"4": {
			HS_DISTANCE: 0
		},
		"5": {
			HS_DISTANCE: 0
		},
		"6": {
			HS_DISTANCE: 0
		},
		"7": {
			HS_DISTANCE: 0
		},
		"8": {
			HS_DISTANCE: 0
		}
	}
}

func _ready():
	loadConfig()
	loadHighScores()

func _on_Exit_pressed():
	get_tree().change_scene(mainMenu)


func startGame():
	randomize()
	get_tree().change_scene(level)

func exitGame():
	get_tree().quit()

func saveConfig():
	Utils.save("user://config.json", config)

func loadConfig():
	var storedConfig = Utils.loadDictionary("user://config.json")
	if storedConfig.size() > 0:
		config = storedConfig
	levelDifficulty = config.levelDifficulty
	setDifficulty(levelDifficulty)
	if storedConfig.has("controls"):
		if storedConfig.get("controls") == 1:
			controls = ControlTypes.CENTRALIZED
		else:
			controls = ControlTypes.CLASSIC

func loadHighScores():
	var loaded = Utils.loadDictionary("user://highScores.json")
	if loaded.size() > 0:
		highScores = loaded

func isNewRecord(score: int):
	return score > highScores[HS_LEVEL][str(levelDifficulty)][HS_DISTANCE]

func saveHighScore(newScore: int):
	var currentScore = highScores[HS_LEVEL][str(levelDifficulty)][HS_DISTANCE]
	if isNewRecord(newScore):
		highScores[HS_LEVEL][str(levelDifficulty)][HS_DISTANCE] = newScore
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


func setControls(newControls):
	config.controls = newControls
	controls = newControls
	saveConfig()


func getHighScore() -> int:
	if highScores.has(HS_LEVEL):
		if highScores[HS_LEVEL].has(str(levelDifficulty)):
			if highScores[HS_LEVEL][str(levelDifficulty)].has(HS_DISTANCE):
				return highScores[HS_LEVEL][str(levelDifficulty)][HS_DISTANCE]
	
	return 0


func getControls():
	return controls


func getControlsIndex():
	return config.controls
