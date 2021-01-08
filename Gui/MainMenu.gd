extends Spatial

func _ready():
	$LevelTemplate/Player.idle()
	$CanvasLayer/CenterContainer/Start

func _on_Start_pressed():
	get_tree().call_group("game", "startGame")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().call_group("game", "startGame")
