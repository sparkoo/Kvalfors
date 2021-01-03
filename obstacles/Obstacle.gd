extends Area

func _on_ObstacleBox_body_entered(body):
	print(body.to_string())
	get_tree().call_group("hittable", "hit")
