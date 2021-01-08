extends KinematicBody

enum PlayerActiveState{RUNNING, JUMP, SLIDE}
enum PlayerState{RUNNING, DEAD, IDLE}

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
		handleSideMoves(delta)
		handleJumpSlideMoves(delta)
		move_and_slide(motion)

func handleSideMoves(delta):
	if Input.is_action_pressed("left") and playerActiveState == PlayerActiveState.RUNNING:
		motion.x = moveToMotion(translation.x, LINE_WIDTH, SIDE_SPEED, delta)
	elif Input.is_action_pressed("right") and playerActiveState == PlayerActiveState.RUNNING:
		motion.x = moveToMotion(translation.x, -LINE_WIDTH, SIDE_SPEED, delta)
	elif playerActiveState == PlayerActiveState.RUNNING:
		motion.x = moveToMotion(translation.x, 0, SIDE_SPEED, delta)

func handleJumpSlideMoves(delta):
	# just change states here, manage animations etc.
	if Input.is_action_just_pressed("jump") and playerActiveState == PlayerActiveState.RUNNING:
		playerActiveState = PlayerActiveState.JUMP
		$Timers/JumpTimer.start()
		animateAction("jump")
	elif Input.is_action_just_pressed("slide") and playerActiveState == PlayerActiveState.RUNNING:
		playerActiveState = PlayerActiveState.SLIDE
		$Timers/SlideTimer.start()
		animateAction("slide")
	elif Input.is_action_just_released("slide") and playerActiveState == PlayerActiveState.SLIDE:
		cancelSlide()
	
	# actual movement is done here, based on player active state
	if playerActiveState == PlayerActiveState.JUMP:
		motion.y = moveToMotion(translation.y, JUMP_HEIGHT, JUMP_SPEED, delta)
	elif playerActiveState == PlayerActiveState.SLIDE:
		motion.y = moveToMotion(translation.y, SLIDE_HEIGHT, JUMP_SPEED, delta)
	elif playerActiveState == PlayerActiveState.RUNNING:
		motion.y = moveToMotion(translation.y, NORMAL_HEIGHT, JUMP_SPEED, delta)

# moves from `from` value to `to` with `speed*delta` speed, unles we're already there.
# If frame distance is over the destination value, go to the destination directly
func moveToMotion(from: float, to: float, speed: float, delta: float, tolerance: float = 0.01):
	# are we already there?
	if not Utils.compare_floats(from, to, 0.01):
		# determine wether speed is globally positive or negative
		# TODO: can be optimized to avoid this condition and handle it in some clever math?
		if to > from:
			# if the frame distance is over the destination
			if from + (speed * delta) > to:
				# move just to the destination
				return (to - from) / delta
			else:
				# move full frame speed
				return speed
		else:
			# same as above only reverse because we're moving to negative
			if from + (speed * delta) < to:
				# move just to the destination
				return (to - from) / delta
			else:
				# move full frame speed
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


func _on_JumpTimer_timeout():
	playerActiveState = PlayerActiveState.RUNNING
	if playerState == PlayerState.RUNNING:
		$PlayerModel/AnimationPlayer.play_backwards("jump")
		run()


func cancelSlide():
	$Timers/SlideTimer.stop()
	playerActiveState = PlayerActiveState.RUNNING
	if playerState == PlayerState.RUNNING:
		$PlayerModel/AnimationPlayer.play_backwards("slide")
		run()

func _on_SlideTimer_timeout():
	cancelSlide()


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
