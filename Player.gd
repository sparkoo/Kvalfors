extends KinematicBody

export var SPEED = 10
export var SIDE_SPEED = 10
export var JUMP_SPEED = 10
export var SLIDE_HEIGHT = .5
export var NORMAL_HEIGHT = 1
export var JUMP_HEIGHT = 1.5

const LINE_WIDTH = 1

var motion = Vector3()

var dead = false

func _ready():
	translation.y = NORMAL_HEIGHT

func _physics_process(delta):
	move()
	
	
func move():
	if not dead:
		motion.z = SPEED
	
		var direction = Input.get_action_strength("left") - Input.get_action_strength("right")
		translation.x = LINE_WIDTH * direction
		
		if Input.is_action_just_pressed("jump") and translation.y == NORMAL_HEIGHT:
			translation.y = JUMP_HEIGHT
			$JumpSlideTimer.start()
		elif Input.is_action_just_pressed("slide") and translation.y == NORMAL_HEIGHT:
			translation.y = SLIDE_HEIGHT
			$JumpSlideTimer.start()
		move_and_slide(motion)


func _on_JumpSlideTimer_timeout():
	translation.y = NORMAL_HEIGHT


func hit():
	dead = true
	get_tree().call_group("game", "gameOver")


func _input(event):
	pass
