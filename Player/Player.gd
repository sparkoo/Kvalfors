extends KinematicBody

enum PlayerActiveState{RUNNING, JUMP, SLIDE}
enum PlayerState{RUNNING, DEAD, IDLE}

export var SPEED = 5
export var SIDE_SPEED = 20
export var JUMP_SPEED = 1
export var NORMAL_HEIGHT = .7
var SLIDE_HEIGHT = -0.35
var JUMP_HEIGHT = 1.2

const LINE_WIDTH = 1

var motion = Vector3()

var playerState = PlayerState.IDLE
var playerActiveState = PlayerActiveState.RUNNING

var distance = 0.0
var lastKnownPosition: Vector3

func _ready():
	run()
	lastKnownPosition = translation

func _physics_process(delta):
	if playerState == PlayerState.RUNNING:
		move()

	
func move():
	if playerState == PlayerState.RUNNING:
		var camera_transform = $Camera.global_transform
#		var direction = Input.get_action_strength("left") - Input.get_action_strength("right")
#		translation.x = LINE_WIDTH * direction
		if Input.is_action_pressed("left"):
			motion.x = moveToMotion(translation.x, LINE_WIDTH, SIDE_SPEED)
		elif Input.is_action_pressed("right"):
			motion.x = moveToMotion(translation.x, -LINE_WIDTH, -SIDE_SPEED)
		else:
			if not Utils.compare_floats(translation.x, 0, 0.01):
				if translation.x < 0:
					motion.x = SIDE_SPEED
				else:
					motion.x = -SIDE_SPEED
			else:
				motion.x = 0
		if Input.is_action_just_pressed("jump") and playerActiveState == PlayerActiveState.RUNNING:
			playerActiveState = PlayerActiveState.JUMP
			jump()
		elif Input.is_action_just_pressed("slide") and playerActiveState == PlayerActiveState.RUNNING:
			playerActiveState = PlayerActiveState.SLIDE
			slide()
		$Camera.global_transform = camera_transform
		
		print(translation.y , " == ", NORMAL_HEIGHT)
		if playerActiveState == PlayerActiveState.JUMP:
			motion.y = moveToMotion(translation.y, JUMP_HEIGHT, JUMP_SPEED)
		elif playerActiveState == PlayerActiveState.SLIDE:
			motion.y = moveToMotion(translation.y, SLIDE_HEIGHT, -JUMP_SPEED)
		elif playerActiveState == PlayerActiveState.RUNNING:
			if not Utils.compare_floats(translation.y, NORMAL_HEIGHT, 0.1):
				if translation.y < NORMAL_HEIGHT:
					motion.y = JUMP_SPEED
				else:
					motion.y = -JUMP_SPEED
			else:
				motion.y = 0
			
		motion.z = SPEED
		move_and_slide(motion)
		updateDistance()

func moveToMotion(from, to, speed, tolerance = 0.01):
	if not Utils.compare_floats(from, to, 0.01):
		return speed
	else:
		return 0

func updateDistance():
	distance += translation.z - lastKnownPosition.z
	lastKnownPosition = translation
	get_tree().call_group("player", "playerDistanceUpdate", distance)

func run():
	playerState = PlayerState.RUNNING
	animateAction("run")


func jump():
	$Timers/JumpTimer.start()
	animateAction("jump")
	

func _on_JumpTimer_timeout():
	playerActiveState = PlayerActiveState.RUNNING
	if playerState == PlayerState.RUNNING:
		$PlayerModel/AnimationPlayer.play_backwards("jump")
		run()


func slide():
	$Timers/SlideTimer.start()
	animateAction("slide")

func _on_SlideTimer_timeout():
	playerActiveState = PlayerActiveState.RUNNING
	if playerState == PlayerState.RUNNING:
		$PlayerModel/AnimationPlayer.play_backwards("slide")
		run()


func animateAction(action):
	$PlayerModel/AnimationPlayer.play(action)
	$Sfx/AudioStreamPlayer.stream = load("res://assets/sfx/%s.ogg" % action)
	$Sfx/AudioStreamPlayer.play()

func hit():
	playerState = PlayerState.DEAD
	resetHeight()
	animateAction("die")
	get_tree().call_group("game", "gameOver")

func idle():
	playerState = PlayerState.IDLE
	animateAction("run")

func resetHeight():
	var camera_transform = $Camera.global_transform
	translation.y = NORMAL_HEIGHT
	$Camera.global_transform = camera_transform
