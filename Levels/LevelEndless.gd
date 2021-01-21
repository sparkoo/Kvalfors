extends "res://Levels/LevelTemplate.gd"

func _ready():
	for n in range(10):
		var nextBlock = generateNext()
		placeObstacles(nextBlock)

func moveGenDetector():
	$LevelRotationMidpoint/Level/GenNextDetector.rotate_x(CURVE_ROT_X)
	$LevelRotationMidpoint/Level/GenNextDetector.translate(ROADBLOCK_SIZE)


func _on_GenNextDetector_body_entered(body: Node):
	var nextBlock = generateNext()
	placeObstacles(nextBlock)
	moveGenDetector()
	cleanup()

func placeObstacles(nextBlock):
	var obstacle = obstacleTypes[randi() % obstacleTypes.size()].instance()
	nextBlock.add_child(obstacle)
	var x
	if obstacle.linesWidth == 3:
		x = 0
	elif obstacle.linesWidth == 2:
		x = (randi() % 2) - 1
	elif obstacle.linesWidth == 1:
		x = (randi() % 3) - 1
	
	obstacle.translate(Vector3(x, 0, 5))
