extends Spatial

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func gameOver():
	$GameOver/Popup.popup_centered()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
