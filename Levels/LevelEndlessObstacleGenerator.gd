extends Node

class_name ObstacleGenerator

const BLOCK = "block"
const JUMP = "jump"
const JUMP_WIDE = "jumpWide"
const SLIDE = "slide"
const SLIDE_WIDE = "slideWide"
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
	JUMP_WIDE: load("res://Obstacles/ObstacleJumpWide.tscn"),
	SLIDE: load("res://Obstacles/ObstacleSlide.tscn"),
	SLIDE_WIDE: load("res://Obstacles/ObstacleSlideWide.tscn"),
	CAR: load("res://Obstacles/ObstacleCar.tscn"),
	TUNNEL: load("res://Obstacles/ObstacleTunnel.tscn"),
	BARREL: load("res://Obstacles/ObstacleBarrel.tscn"),
	BARREL_STACK: load("res://Obstacles/ObstacleBarrelStack.tscn"),
	CROSSING_GATE: load("res://Obstacles/ObstacleCrossingGate.tscn"),
	BOX: load("res://Obstacles/ObstacleBox.tscn"),
	BOX_STACK: load("res://Obstacles/ObstacleBoxStack.tscn"),
	
}

var oneLineObstacles = {
	BLOCK: obstacleTypes[BLOCK],
	JUMP: obstacleTypes[JUMP], 
	SLIDE: obstacleTypes[SLIDE], 
	CAR: obstacleTypes[CAR], 
	BARREL: obstacleTypes[BARREL], 
	BOX: obstacleTypes[BOX]
}

var level0Obstacles: Dictionary
var level1Obstacles: Dictionary
var level2Obstacles: Dictionary
var level3Obstacles: Dictionary
var level4Obstacles: Dictionary

func init():
	level0Obstacles = oneLineObstacles.duplicate()
	level0Obstacles[TUNNEL] = obstacleTypes[TUNNEL]
	
	level1Obstacles = level0Obstacles.duplicate()
	
	level2Obstacles = level1Obstacles.duplicate()
	level2Obstacles[BOX_STACK] = obstacleTypes[BOX_STACK]
	level2Obstacles[BARREL_STACK] = obstacleTypes[BARREL_STACK]
	
	level3Obstacles = level2Obstacles.duplicate()
	level3Obstacles[CROSSING_GATE] = obstacleTypes[CROSSING_GATE]
	level3Obstacles[JUMP_WIDE] = obstacleTypes[JUMP_WIDE]
	
	level4Obstacles = level3Obstacles.duplicate()
	level3Obstacles[SLIDE_WIDE] = obstacleTypes[SLIDE_WIDE]
	

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

func pickAndPut(nextBlock: StaticBody, obstacles: Dictionary, x: int = -1, z: int = -1):
	var obstacleKey = getRandomKey(obstacles)
	var obstacle = obstacles.get(obstacleKey).instance()
	
	if x <= -1:
		if obstacle.linesWidth == 3:
			x = 0
		elif obstacle.linesWidth == 2:
			x = (randi() % 2) - 1
		elif obstacle.linesWidth == 1:
			x = (randi() % 3) - 1
	
	if z <= -1:
		z = 8 - (randi() % 5)
	
	putObstacle(nextBlock, obstacle, Vector3(x, 0, z))

func level0(nextBlock: StaticBody, blockCounter: int):
	var obstacleKey = getRandomKey(level0Obstacles)
	
	var x = 1 if blockCounter % 2 == 0 else -1
	if obstacleKey == TUNNEL:
		x = 0
		
	var obstacle = level0Obstacles[obstacleKey].instance()
	putObstacle(nextBlock, obstacle, Vector3(x, 0, 8 - (randi() % 5)))


func level1(nextBlock: StaticBody, blockCounter: int):
	if blockCounter % 4 != 0:
		return
	
	pickAndPut(nextBlock, level1Obstacles, 0)

func level2(nextBlock : StaticBody, blockCounter : int):
	if blockCounter % 4 != 0:
		return
	
	pickAndPut(nextBlock, level2Obstacles)

func level3(nextBlock : StaticBody, blockCounter : int):
	if blockCounter % 4 != 0:
		return
	
	pickAndPut(nextBlock, level3Obstacles)

func level4(nextBlock : StaticBody, blockCounter : int):
	if blockCounter % 4 != 0:
		return
	
	pickAndPut(nextBlock, level4Obstacles)

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

func getRandomKey(dict: Dictionary):
	return dict.keys()[randi() % dict.size()]
