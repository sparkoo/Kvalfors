extends Node

var menuSoundtrack = load("res://assets/soundtrack/Crowander - Crash.ogg")
var playSoundtrack = [
	load("res://assets/soundtrack/Anamanaguchi - Fast Turtle.ogg"),
	load("res://assets/soundtrack/Andrew Codeman - Run.ogg"),
	load("res://assets/soundtrack/Büromaschinen - Run.ogg"),
	load("res://assets/soundtrack/Lloyd Rodgers - 1 - Fast.ogg"),
	load("res://assets/soundtrack/Pistol Jazz - God Speed (instrumental version).ogg")
]
var playSoundtrackCurrentI = 0

func _ready():
	randomize()
	playSoundtrack.shuffle()

func playMenu():
	play(menuSoundtrack)

func playGame():
	play(playSoundtrack[playSoundtrackCurrentI])
	playSoundtrackCurrentI += 1

func play(res: Resource):
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = res
	$AudioStreamPlayer.play()
