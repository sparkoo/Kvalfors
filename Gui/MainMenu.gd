extends Spatial

func _ready():
	$LevelTemplate/Player.idle()
	$CanvasLayer/CenterContainer/Start

func _on_Start_pressed():
	get_tree().call_group("game", "startGame")
