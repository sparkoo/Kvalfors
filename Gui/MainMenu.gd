extends Spatial

func _ready():
	$LevelTemplate/Player.idle()

func _on_Start_pressed():
	get_tree().call_group("game", "startGame")
