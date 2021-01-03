extends Area

func _on_ObstacleBox_body_entered(body):
	get_tree().call_group("hittable", "hit")
