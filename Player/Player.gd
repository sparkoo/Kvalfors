extends KinematicBody

enum PlayerActiveState{RUNNING, JUMP, SLIDE}
enum PlayerState{RUNNING, DEAD, IDLE}

export var SPEED = 5
export var SIDE_SPEED = 10
export var JUMP_SPEED = 10
export var NORMAL_HEIGHT = .7
var SLIDE_HEIGHT = -0.35
var JUMP_HEIGHT = 0.5

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
		var direction = Input.get_action_strength("left") - Input.get_action_strength("right")
		translation.x = LINE_WIDTH * direction
		if Input.is_action_just_pressed("jump") and Utils.compare_floats(translation.y, NORMAL_HEIGHT):
			jump()
		elif Input.is_action_just_pressed("slide") and Utils.compare_floats(translation.y, NORMAL_HEIGHT):
			slide()
		$Camera.global_transform = camera_transform
		
		motion.z = SPEED
		move_and_slide(motion)
		updateDistance()


func updateDistance():
	distance += lastKnownPosition.distance_to(translation)
	lastKnownPosition = translation
	get_tree().call_group("player", "playerDistanceUpdate", distance)

func run():
	playerState = PlayerState.RUNNING
	resetHeight()
	animateAction("run")


func jump():
	print("jump")
	translate(Vector3(0, JUMP_HEIGHT, 0))
	$Timers/JumpTimer.start()
	animateAction("jump")
	

func _on_JumpTimer_timeout():
	if playerState == PlayerState.RUNNING:
		$PlayerModel/AnimationPlayer.play_backwards("jump")
		run()


func slide():
	translate(Vector3(0, SLIDE_HEIGHT, 0))
	$Timers/SlideTimer.start()
	animateAction("slide")

func _on_SlideTimer_timeout():
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
