extends Node

func _on_Button_pressed():
	get_tree().reload_current_scene()

func _on_Exit_pressed():
	get_tree().quit()

func startGame():
	get_tree().change_scene("res://Levels/LevelEndless.tscn")
