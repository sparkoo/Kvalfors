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

var multiLineObstacles = {
	JUMP_WIDE: obstacleTypes[JUMP_WIDE],
	SLIDE_WIDE: obstacleTypes[SLIDE_WIDE],
	BARREL_STACK: obstacleTypes[BARREL_STACK],
	CROSSING_GATE: obstacleTypes[CROSSING_GATE],
	BOX_STACK: obstacleTypes[BOX_STACK],
	TUNNEL: obstacleTypes[TUNNEL]
}

var block = {
	BLOCK: obstacleTypes[BLOCK]
}

var oneLinersWithoutBlock: Dictionary
var level0Obstacles: Dictionary
var level1Obstacles: Dictionary
var level2Obstacles: Dictionary
var level3Obstacles: Dictionary
var level4Obstacles: Dictionary

func init():
	oneLinersWithoutBlock = oneLineObstacles.duplicate()
	oneLinersWithoutBlock.erase(BLOCK)
	
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
	level4Obstacles[SLIDE_WIDE] = obstacleTypes[SLIDE_WIDE]
	

func placeObstacles(nextBlock : StaticBody, blockCounter : int, difficulty : int = 0):
	if difficulty >= 1 and difficulty <= 5:
		if blockCounter % 4 != 0:
			return
	elif difficulty == 6:
		if blockCounter % 3 != 0:
			return
	elif difficulty == 7:
		if blockCounter % 2 != 0:
			return
	
	match difficulty:
		0:
			level0(nextBlock, blockCounter)
		1:
			level1(nextBlock, blockCounter)
		2:
			randObstacles(nextBlock, level2Obstacles)
		3:
			randObstacles(nextBlock, level3Obstacles)
		4:
			randObstacles(nextBlock, level4Obstacles)
		5:
			randObstacles(nextBlock, level4Obstacles)
		6:
			randObstaclesWithCombos(nextBlock, level4Obstacles)
		7:
			randObstaclesWithCombos(nextBlock, level4Obstacles)
		8:
			randObstaclesWithCombos(nextBlock, level4Obstacles)
		9:
			randObstaclesWithCombos(nextBlock, level4Obstacles)
		_:
			randObstaclesWithCombos(nextBlock, level4Obstacles)

func putObstacle(nextBlock: StaticBody, obstacle: Obstacle, position: Vector3):
	nextBlock.add_child(obstacle)
	obstacle.translate(position)

func pickAndPut(nextBlock: StaticBody, obstacles: Dictionary, x: int = -999, z: int = -1):
	var obstacleKey = getRandomKey(obstacles)
	var obstacle = obstacles.get(obstacleKey).instance()
	
	if x == -999:
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
	pickAndPut(nextBlock, level1Obstacles, 0)

func randObstacles(nextBlock: StaticBody, obstaclesDict: Dictionary):
	pickAndPut(nextBlock, obstaclesDict)

func randObstaclesWithCombos(nextBlock : StaticBody, obstaclesDict: Dictionary):
	if randi() % 3 != 0:
		pickAndPut(nextBlock, multiLineObstacles)
	else:
		var z = 8 - (randi() % 5)
		pickAndPut(nextBlock, oneLinersWithoutBlock, -1)
		pickAndPut(nextBlock, oneLineObstacles, 0)
		pickAndPut(nextBlock, oneLinersWithoutBlock, 1)

func getRandomKey(dict: Dictionary):
	return dict.keys()[randi() % dict.size()]
