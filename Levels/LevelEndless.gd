extends "res://Levels/LevelTemplate.gd"

onready var obstacleGenerator : ObstacleGenerator = preload("LevelEndlessObstacleGenerator.gd").new()

func _ready():
	obstacleGenerator.init()
	speed = 1
	for n in range(10):
		var nextBlock = generateNext()
		if n >= 1:
			obstacleGenerator.placeObstacles(nextBlock, blockCounter, Game.levelDifficulty)
	$Gui/PlayGui/Difficulty.text = "Difficulty: %s" % Game.levelDifficulty


func moveGenDetector():
	$LevelRotationMidpoint/Level/GenNextDetector.rotate_x(CURVE_ROT_X)
	$LevelRotationMidpoint/Level/GenNextDetector.translate(ROADBLOCK_SIZE)


# warning-ignore:unused_argument
func _on_GenNextDetector_body_entered(body: Node):
	var nextBlock : StaticBody = generateNext()
	obstacleGenerator.placeObstacles(nextBlock, blockCounter, Game.levelDifficulty)
	moveGenDetector()
	cleanup()
