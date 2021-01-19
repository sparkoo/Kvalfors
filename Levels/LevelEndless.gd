extends "res://Levels/LevelTemplate.gd"

var obstacleTypes = [
	load("res://Obstacles/ObstacleBlock.tscn"),
	load("res://Obstacles/ObstacleJump.tscn"),
	load("res://Obstacles/ObstacleSlide.tscn"),
	load("res://Obstacles/ObstacleCar.tscn"),
	load("res://Obstacles/ObstacleTunnel.tscn")
]

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
	obstacle.translate(Vector3((randi() % 3) - 1, 0, randi() % 10))
