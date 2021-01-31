extends Node

const FLOAT_EPSILON = 0.00001

static func compare_floats(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon

func save(var path : String, var thingToSave):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(JSON.print(thingToSave))
	file.close()

func loadDictionary(var path : String) -> Dictionary:
	var file = File.new()
	var openErr = file.open(path, File.READ)
	if openErr != OK:
		return {}
	var content = file.get_line()
	file.close()
	var parseResult = JSON.parse(content)
	if parseResult.error == OK:
		return JSON.parse(content).result
	else:
		return {}
