extends "res://Levels/LevelTemplate.gd"

var tunnel = load("res://Obstacles/ObstacleTunnel.tscn")

func _ready():
	generateNext()
	var block = generateNext()
	placeTunnel(block)
	generateNext()
	generateNext()
	generateNext()

func placeTunnel(nextBlock):
	var obstacle = tunnel.instance()
	nextBlock.add_child(obstacle)
	obstacle.translate(Vector3(0, 0, 5))
