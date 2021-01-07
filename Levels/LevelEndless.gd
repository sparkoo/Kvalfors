extends "res://Levels/LevelTemplate.gd"

func _on_GenNext_body_entered(body: KinematicBody):
	print("generating")
	var nextBlock: StaticBody = load("res://LevelBits/RoadBlock.tscn").instance()
	add_child(nextBlock)
	nextBlock.translate($Env/NextPosition.translation)
	$Env/NextPosition.translate(Vector3(0, 0, 10))
	$Env/GenNext.translate(Vector3(0, 0, 10))
