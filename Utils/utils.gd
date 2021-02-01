extends Node

const FLOAT_EPSILON = 0.00001

static func compare_floats(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon

func save(var path : String, var thingToSave):
	print("saving %s" % path)
	var file = File.new()
	var openErr = file.open(path, File.WRITE)
	if openErr != OK:
		print("failed to open the file %s" % path)
	file.store_line(JSON.print(thingToSave))
	file.close()

func loadDictionary(var path : String) -> Dictionary:
	var file = File.new()
	var openErr = file.open(path, File.READ)
	if openErr != OK:
		print("failed to open the file %s" % path)
		print(openErr)
		return {}
	var content = file.get_line()
	print("opened file %s" % path)
	print(content)
	file.close()
	var parseResult = JSON.parse(content)
	if parseResult.error == OK:
		return JSON.parse(content).result
	else:
		return {}
