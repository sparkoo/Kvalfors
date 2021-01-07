extends Area

func _on_ObstacleBox_body_entered(body):
	if body is KinematicBody:
		get_tree().call_group("hittable", "hit")
