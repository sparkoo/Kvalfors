extends Node

const FLOAT_EPSILON = 0.00001

static func compare_floats(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon

func save(var path : String, var thing_to_save):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_var(thing_to_save)
	file.close()

func loadDictionary (var path : String) -> Dictionary:
	var file = File.new()
	file.open(path, File.READ)
	var theDict = file.get_var()
	file.close()
	return theDict
