extends "res://Levels/LevelTemplate.gd"

onready var obstacleGenerator : ObstacleGenerator = preload("LevelEndlessObstacleGenerator.gd").new()

export var difficulty = 1

func _ready():
	speed = 0.5
	for n in range(10):
		var nextBlock = generateNext()
		if n > 2:
			obstacleGenerator.placeObstacles(nextBlock, blockCounter)


func moveGenDetector():
	$LevelRotationMidpoint/Level/GenNextDetector.rotate_x(CURVE_ROT_X)
	$LevelRotationMidpoint/Level/GenNextDetector.translate(ROADBLOCK_SIZE)


# warning-ignore:unused_argument
func _on_GenNextDetector_body_entered(body: Node):
	var nextBlock : StaticBody = generateNext()
	obstacleGenerator.placeObstacles(nextBlock, blockCounter, difficulty)
	moveGenDetector()
	cleanup()

