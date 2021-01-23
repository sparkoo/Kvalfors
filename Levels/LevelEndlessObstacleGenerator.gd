extends Node

class_name ObstacleGenerator

const BLOCK = "block"
const JUMP = "jump"
const SLIDE = "slide"
const CAR = "car"
const TUNNEL = "tunnel"
const BARREL = "barrel"
const BARREL_STACK = "barrelStack"
const CROSSING_GATE = "crossingGate"
const BOX = "box"
const BOX_STACK = "boxStack"

var obstacleTypes = {
	BLOCK: load("res://Obstacles/ObstacleBlock.tscn"),
	JUMP: load("res://Obstacles/ObstacleJump.tscn"),
	SLIDE: load("res://Obstacles/ObstacleSlide.tscn"),
	CAR: load("res://Obstacles/ObstacleCar.tscn"),
	TUNNEL: load("res://Obstacles/ObstacleTunnel.tscn"),
	BARREL: load("res://Obstacles/ObstacleBarrel.tscn"),
	BARREL_STACK: load("res://Obstacles/ObstacleBarrelStack.tscn"),
	CROSSING_GATE: load("res://Obstacles/ObstacleCrossingGate.tscn"),
	BOX: load("res://Obstacles/ObstacleBox.tscn"),
	BOX_STACK: load("res://Obstacles/ObstacleBoxStack.tscn")
}

var oneLineObstacles = [
	obstacleTypes[BLOCK],
	obstacleTypes[JUMP], 
	obstacleTypes[SLIDE], 
	obstacleTypes[CAR], 
	obstacleTypes[BARREL], 
	obstacleTypes[BOX]
]


func placeObstacles(nextBlock : StaticBody, blockCounter : int, difficulty : int = 0):
	match difficulty:
		0:
			level0(nextBlock, blockCounter)
		1:
			level1(nextBlock, blockCounter)
		2:
			level2(nextBlock, blockCounter)
		3:
			level3(nextBlock, blockCounter)
		4:
			level4(nextBlock, blockCounter)
		5:
			level5(nextBlock, blockCounter)
		6:
			level6(nextBlock, blockCounter)
		7:
			level7(nextBlock, blockCounter)
		8:
			level8(nextBlock, blockCounter)
		9:
			level9(nextBlock, blockCounter)
		_:
			level10(nextBlock, blockCounter)

func putObstacle(nextBlock: StaticBody, obstacle: Obstacle, position: Vector3):
	nextBlock.add_child(obstacle)
	obstacle.translate(position)


func level0(nextBlock: StaticBody, blockCounter: int):
	var x = 1 if blockCounter % 2 == 0 else -1
	var obstacle = oneLineObstacles[randi() % oneLineObstacles.size()].instance()
	putObstacle(nextBlock, obstacle, Vector3(x, 0, 8 - (randi() % 5)))
	
#	var x
#	if obstacle.linesWidth == 3:
#		x = 0
#	elif obstacle.linesWidth == 2:
#		x = (randi() % 2) - 1
#	elif obstacle.linesWidth == 1:
#		x = (randi() % 3) - 1

func level1(nextBlock: StaticBody, blockCounter: int):
	var x
	if blockCounter % 5 == 0:
		x = 0
	else:
		x = 1 if blockCounter % 2 == 0 else -1
	var obstacle = oneLineObstacles[randi() % oneLineObstacles.size()].instance()
	putObstacle(nextBlock, obstacle, Vector3(x, 0, 8 - (randi() % 5)))

func level2(nextBlock : StaticBody, blockCounter : int):
	pass

func level3(nextBlock : StaticBody, blockCounter : int):
	pass

func level4(nextBlock : StaticBody, blockCounter : int):
	pass

func level5(nextBlock : StaticBody, blockCounter : int):
	pass

func level6(nextBlock : StaticBody, blockCounter : int):
	pass

func level7(nextBlock : StaticBody, blockCounter : int):
	pass

func level8(nextBlock : StaticBody, blockCounter : int):
	pass

func level9(nextBlock : StaticBody, blockCounter : int):
	pass

func level10(nextBlock : StaticBody, blockCounter : int):
	pass
