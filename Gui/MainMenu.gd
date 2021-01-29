extends Spatial

onready var difficultyLabel = $CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/Difficulty

func _ready():
	$CanvasLayer/CenterContainer/Start
	difficultyLabel.text = String(Game.levelDifficulty)


func _on_Start_pressed():
	Game.startGame()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Game.startGame()


func _on_DifficultyUp_pressed():
	Game.updateDifficultyBy(1)
	difficultyLabel.text = String(Game.levelDifficulty)


func _on_DifficultyDown_pressed():
	Game.updateDifficultyBy(-1)
	difficultyLabel.text = String(Game.levelDifficulty)

func _on_Exit_pressed():
	Game.exitGame()
