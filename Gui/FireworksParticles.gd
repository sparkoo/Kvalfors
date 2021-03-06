extends CPUParticles

class_name FireworksParticles

const SPEED = 10
var move = true

func _ready():
	var material = SpatialMaterial.new()
	var color = ColorPallete.randomColor()
	material.albedo_color = color
	material.emission_enabled = true
	material.emission_energy = 5
	material.emission = color
	set_material_override(material)

func _on_Timer_timeout():
	queue_free()

func _process(delta):
	if move:
		translate(Vector3(0, 0, -SPEED * delta))
