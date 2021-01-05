extends KinematicBody

export var SPEED = 5
export var SIDE_SPEED = 10
export var JUMP_SPEED = 10
export var NORMAL_HEIGHT = .7
var SLIDE_HEIGHT = -0.35
var JUMP_HEIGHT = 0.5

const LINE_WIDTH = 1

var motion = Vector3()

var dead = false

func _ready():
	run()

func _physics_process(delta):
	move()

	
func move():
	if not dead:
		var camera_transform = $Camera.global_transform
		var direction = Input.get_action_strength("left") - Input.get_action_strength("right")
		translation.x = LINE_WIDTH * direction
		
		if Input.is_action_just_pressed("jump") and Utils.compare_floats(translation.y, NORMAL_HEIGHT):
			jump()
		elif Input.is_action_just_pressed("slide") and Utils.compare_floats(translation.y, NORMAL_HEIGHT):
			slide()
		$Camera.global_transform = camera_transform
		
		motion.z = SPEED
		move_and_slide(motion)


func run():
	if not dead:
		resetHeight()
		animateAction("run")


func jump():
	print("jump")
	translate(Vector3(0, JUMP_HEIGHT, 0))
	$Timers/JumpTimer.start()
	animateAction("jump")
	

func _on_JumpTimer_timeout():
	if not dead:
		$PlayerModel/AnimationPlayer.play_backwards("jump")
		run()


func slide():
	translate(Vector3(0, SLIDE_HEIGHT, 0))
	$Timers/SlideTimer.start()
	animateAction("slide")

func _on_SlideTimer_timeout():
	if not dead:
		$PlayerModel/AnimationPlayer.play_backwards("slide")
		run()


func animateAction(action):
	$PlayerModel/AnimationPlayer.play(action)
	$Sfx/AudioStreamPlayer.stream = load("res://assets/sfx/%s.ogg" % action)
	$Sfx/AudioStreamPlayer.play()

func hit():
	dead = true
	resetHeight()
	animateAction("die")
	get_tree().call_group("game", "gameOver")


func resetHeight():
	var camera_transform = $Camera.global_transform
	translation.y = NORMAL_HEIGHT
	$Camera.global_transform = camera_transform
