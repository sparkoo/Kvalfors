extends Spatial

var particles = load("res://GUI/FireworksParticles.tscn")

var emitting = false

func emit(period: int):
	emitting = true
	$EmitTimer.start(period)

func _on_Timer_timeout():
	if emitting:
		var newParticles = particles.instance()
		add_child(newParticles)
		var x = randi() % 4 - 2
		var y = randi() % 4 - 2
		var z = randi() % 4 - 2
		newParticles.translate(Vector3(x, y, z))
		newParticles.emitting = true
		$Timer.wait_time = rand_range(0.1, 0.5)


func _on_EmitTimer_timeout():
	emitting = false
