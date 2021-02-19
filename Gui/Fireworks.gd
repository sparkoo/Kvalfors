extends Spatial

var particles = load("res://Gui/FireworksParticles.tscn")

var emitting = false
var move = true

func emit(period: int, shouldMove: bool = true):
	emitting = true
	move = shouldMove
	if period > 0:
		$EmitTimer.start(period)
	else:
		$EmitTimer.stop()

func _on_Timer_timeout():
	if emitting:
		var newParticles: FireworksParticles = particles.instance()
		newParticles.move = move
		add_child(newParticles)
		var x = randi() % 4 - 2
		var y = randi() % 4 - 2
		var z = randi() % 4 - 2
		newParticles.translate(Vector3(x, y, z))
		newParticles.emitting = true
		$Timer.wait_time = rand_range(0.5, 1)


func _on_EmitTimer_timeout():
	print("ende slus")
	emitting = false
