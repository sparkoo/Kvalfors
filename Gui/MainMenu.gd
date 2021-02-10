extends Spatial

onready var difficultyLabel = $CanvasLayer/CenterContainer/VBoxContainer/HBoxDifficulty/Difficulty
onready var highScoreLabel = $CanvasLayer/CenterContainer/VBoxContainer/HighScore
onready var controlsButton = $CanvasLayer/CenterContainer/VBoxContainer/HBoxControls/Controls

func _ready():
	difficultyLabel.text = String(Game.levelDifficulty)
	highScoreLabel.text = "High Score: %s" % Game.getHighScore()
	Soundtrack.playMenu()
	initControlsButton()


func initControlsButton():
	controlsButton.add_item("Classic")
	controlsButton.add_item("Dancepad")
	controlsButton.select(Game.getControlsIndex())

func _on_Start_pressed():
	Game.startGame()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Game.startGame()


func _on_DifficultyUp_pressed():
	Game.updateDifficultyBy(1)
	difficultyLabel.text = String(Game.levelDifficulty)
	highScoreLabel.text = "High Score: %s" % Game.getHighScore()


func _on_DifficultyDown_pressed():
	Game.updateDifficultyBy(-1)
	difficultyLabel.text = String(Game.levelDifficulty)	
	highScoreLabel.text = "High Score: %s" % Game.getHighScore()

func _on_Exit_pressed():
	Game.exitGame()


func _on_Controls_item_selected(index):
	if index == 1:
		Game.setControls(Game.ControlTypes.CENTRALIZED)
	else:
		Game.setControls(Game.ControlTypes.CLASSIC)
