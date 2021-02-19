extends Node

var menuSoundtrack = load("res://assets/soundtrack/menu1.ogg")
var playSoundtrack = [
	load("res://assets/soundtrack/game1.ogg"),
	load("res://assets/soundtrack/game2.ogg"),
	load("res://assets/soundtrack/game3.ogg"),
	load("res://assets/soundtrack/game4.ogg"),
	load("res://assets/soundtrack/game5.ogg")
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
