extends Area

class_name Obstacle

export var linesWidth = 1


func _on_ObstacleBox_body_entered(body):
	if body is KinematicBody:
		get_tree().call_group("hittable", "hit")


func _on_Area_body_entered(body):
	get_tree().call_group("game", "lowerCam")


func _on_Area_body_exited(body):
	get_tree().call_group("game", "defaultCam")
