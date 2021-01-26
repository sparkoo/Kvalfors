extends "res://Levels/LevelTemplate.gd"

onready var obstacleGenerator : ObstacleGenerator = preload("LevelEndlessObstacleGenerator.gd").new()

export var difficulty = 8

func _ready():
	obstacleGenerator.init()
	speed = 1
	setDifficulty(difficulty)
	for n in range(10):
		var nextBlock = generateNext()
		if n >= 1:
			obstacleGenerator.placeObstacles(nextBlock, blockCounter, difficulty)


func moveGenDetector():
	$LevelRotationMidpoint/Level/GenNextDetector.rotate_x(CURVE_ROT_X)
	$LevelRotationMidpoint/Level/GenNextDetector.translate(ROADBLOCK_SIZE)


# warning-ignore:unused_argument
func _on_GenNextDetector_body_entered(body: Node):
	var nextBlock : StaticBody = generateNext()
	obstacleGenerator.placeObstacles(nextBlock, blockCounter, difficulty)
	moveGenDetector()
	cleanup()

func updateDifficultyTo(newDifficulty: int):
	setDifficulty(newDifficulty)

func updateDifficultyBy(step: int):
	setDifficulty(difficulty + step)

func setDifficulty(newValue: int):
	if newValue < 0:
		difficulty = 0
	elif newValue > 8:
		difficulty = 8
	else:
		difficulty = newValue
	get_tree().call_group("level", "difficultyUpdate", difficulty)
