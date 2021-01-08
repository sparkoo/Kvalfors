extends "res://Levels/LevelTemplate.gd"

func _ready():
	for n in range(10):
		generateNext()

func moveGenDetector():
	$Level/GenNextDetector.translate(ROADBLOCK_SIZE)


func _on_GenNextDetector_body_entered(body: Node):
	generateNext()
	moveGenDetector()
	cleanup()
