extends Node

class_name ObstacleGenerator

var obstacleFreq = 1


var obstacleTypes = [
	load("res://Obstacles/ObstacleBlock.tscn"),
	load("res://Obstacles/ObstacleJump.tscn"),
	load("res://Obstacles/ObstacleSlide.tscn"),
	load("res://Obstacles/ObstacleCar.tscn"),
	load("res://Obstacles/ObstacleTunnel.tscn"),
	load("res://Obstacles/ObstacleBarrel.tscn"),
	load("res://Obstacles/ObstacleBarrelStack.tscn"),
	load("res://Obstacles/ObstacleCrossingGate.tscn"),
	load("res://Obstacles/ObstacleBox.tscn"),
	load("res://Obstacles/ObstacleBoxStack.tscn")
]

func init(obstacleFreqArg):
	obstacleFreq = obstacleFreqArg

func placeObstacles(nextBlock, blockCounter):
	if blockCounter % obstacleFreq != 0:
		return
	
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
