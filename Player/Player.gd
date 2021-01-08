extends KinematicBody

enum PlayerActiveState{RUNNING, JUMP, SLIDE}
enum PlayerState{RUNNING, DEAD, IDLE}

export var SPEED = 5
export var SIDE_SPEED = 15
export var JUMP_SPEED = 10
export var NORMAL_HEIGHT = .7
var SLIDE_HEIGHT = 0.35
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

func _physics_process(delta: float):
	if playerState == PlayerState.RUNNING:
		move(delta)

	
func move(delta: float):
	if playerState == PlayerState.RUNNING:
		if Input.is_action_pressed("left"):
			motion.x = moveToMotion(translation.x, LINE_WIDTH, SIDE_SPEED, delta)
		elif Input.is_action_pressed("right"):
			motion.x = moveToMotion(translation.x, -LINE_WIDTH, SIDE_SPEED, delta)
		else:
			motion.x = moveToMotion(translation.x, 0, SIDE_SPEED, delta)
				
		if Input.is_action_just_pressed("jump") and playerActiveState == PlayerActiveState.RUNNING:
			playerActiveState = PlayerActiveState.JUMP
			jump()
		elif Input.is_action_just_pressed("slide") and playerActiveState == PlayerActiveState.RUNNING:
			playerActiveState = PlayerActiveState.SLIDE
			slide()
		
		if playerActiveState == PlayerActiveState.JUMP:
			motion.y = moveToMotion(translation.y, JUMP_HEIGHT, JUMP_SPEED, delta)
		elif playerActiveState == PlayerActiveState.SLIDE:
			motion.y = moveToMotion(translation.y, SLIDE_HEIGHT, JUMP_SPEED, delta)
		elif playerActiveState == PlayerActiveState.RUNNING:
			motion.y = moveToMotion(translation.y, NORMAL_HEIGHT, JUMP_SPEED, delta)
		
		var blocks = get_tree().get_root().find_node("Level", true, false)
		blocks.translate(Vector3(0, 0, SPEED * delta * -1))
		
#		motion.z = SPEED
#		print(motion)
		move_and_slide(motion)
#		$Camera.translate(Vector3(motion.x * delta, -motion.y * delta, 0))
		updateDistance()

func moveToMotion(from: float, to: float, speed: float, delta: float, tolerance: float = 0.01):
	if not Utils.compare_floats(from, to, 0.01):
		if to > from:
			if from + (speed * delta) > to:
				return (to - from) / delta
			else:
				return speed
		else:
			if from + (speed * delta) < to:
				return (to - from) / delta
			else:
				return -speed
	else:
		return 0

func updateDistance():
	distance += translation.z - lastKnownPosition.z
	lastKnownPosition = translation
	get_tree().call_group("player", "playerDistanceUpdate", distance)

func run():
	playerState = PlayerState.RUNNING
	animateAction("run", true)


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


func animateAction(action, queue: bool = false):
	if queue:
		$PlayerModel/AnimationPlayer.queue(action)
	else:
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
