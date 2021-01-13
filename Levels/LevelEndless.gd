extends "res://Levels/LevelTemplate.gd"

var obstacles = [
	load("res://Obstacles/ObstacleBlock.tscn"),
	load("res://Obstacles/ObstacleJump.tscn"),
	load("res://Obstacles/ObstacleSlide.tscn")
]

func _ready():
	for n in range(10):
		generateNext()

func moveGenDetector():
	$LevelRotationMidpoint/Level/GenNextDetector.rotate_x(CURVE_ROT_X)
	$LevelRotationMidpoint/Level/GenNextDetector.translate(ROADBLOCK_SIZE)


func _on_GenNextDetector_body_entered(body: Node):
	var nextBlock = generateNext()
#	placeObstacles(nextBlock)
	moveGenDetector()
	cleanup()

func placeObstacles(nextBlock):
	var obstacle = obstacles[randi() % obstacles.size()].instance()
	nextBlock.add_child(obstacle)
	obstacle.translate(Vector3((randi() % 3) - 1, 0, randi() % 10))
