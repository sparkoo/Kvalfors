extends "res://Levels/LevelTemplate.gd"

func _ready():
	for n in range(5):
		generateNext()
