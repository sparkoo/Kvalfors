extends KinematicBody

enum PlayerActiveState{RUNNING, JUMP, SLIDE}
enum PlayerState{RUNNING, DEAD, IDLE}

export var SIDE_SPEED = 15
export var JUMP_SPEED = 7
export var NORMAL_HEIGHT = .7
var SLIDE_HEIGHT = 0.35
var JUMP_HEIGHT = 1.2
const NORMAL_SHAPE_HEIGHT = 0.6
const SLIDE_SHAPE_HEIGHT = 0.2

const LINE_WIDTH = 1

const UP = Vector3(0, 1, 0)
var motion = Vector3()
const G = -.25

var playerState = PlayerState.IDLE
var playerActiveState = PlayerActiveState.RUNNING
var currentLine = 0

var distance = 0.0

func _ready():
	$PlayerModel/AnimationPlayer.get_animation("run").loop = true
	$PlayerModel/AnimationPlayer.get_animation("idle").loop = true
	animateAction("idle")

func _physics_process(delta: float):
	if playerState == PlayerState.RUNNING:
		move(delta)
	else:
		motion.x = 0
		motion.y += G
	
	move_and_slide(motion, UP, true)	# stop on slope false to stop Z movement

func move(delta: float):
	handleSideMoves(delta)
	handleVerticalMoves(delta)
	motion.z = -global_transform.origin.z	# autocorrect Z

func handleSideMoves(delta):
	# allow change lines only when running
	if playerActiveState == PlayerActiveState.RUNNING and is_on_floor():
		calcCurrentLine()
	
	motion.x = moveToMotion(translation.x, LINE_WIDTH * currentLine, SIDE_SPEED, delta)

func calcCurrentLine():
	if Game.getControls() == Game.ControlTypes.CLASSIC:
		if Input.is_action_just_pressed("left") and currentLine <= 0:
			currentLine += 1
		elif Input.is_action_just_pressed("right") and currentLine >= 0:
			currentLine -= 1
	else:
		currentLine = Input.get_action_strength("left") - Input.get_action_strength("right")

func handleVerticalMoves(delta):
	if !is_on_floor():
		motion.y += G
	elif Input.is_action_just_pressed("jump") and playerActiveState == PlayerActiveState.RUNNING:
		playerActiveState = PlayerActiveState.JUMP
		motion.y = JUMP_SPEED
		animateAction("jump")
		$Timers/JumpTimer.start()
	elif Input.is_action_just_pressed("slide") and playerActiveState == PlayerActiveState.RUNNING:
		playerActiveState = PlayerActiveState.SLIDE
		$CollisionShape.shape.extents.y = SLIDE_SHAPE_HEIGHT
		animateAction("slide")
		$Timers/SlideTimer.start()
	elif Input.is_action_just_released("slide") and playerActiveState == PlayerActiveState.SLIDE:
		cancelSlide()


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

func start():
	playerState = PlayerState.RUNNING
	playerActiveState = PlayerActiveState.RUNNING
	animateAction("run")

func run():
	playerState = PlayerState.RUNNING
	playerActiveState = PlayerActiveState.RUNNING
	animateAction("run", true)


func _on_JumpTimer_timeout():
	playerActiveState = PlayerActiveState.RUNNING
	if playerState == PlayerState.RUNNING:
		$PlayerModel/AnimationPlayer.play_backwards("jump")
		run()


func cancelSlide():
	$CollisionShape.shape.extents.y = NORMAL_SHAPE_HEIGHT
	$PlayerModel/AnimationPlayer.play_backwards("slide")
	$Timers/SlideTimer.stop()
	run()

func _on_SlideTimer_timeout():
	if playerState == PlayerState.RUNNING:
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
	$CollisionShape.shape.extents.y = NORMAL_SHAPE_HEIGHT
	animateAction("die")
	get_tree().call_group("game", "gameOver")

func idle():
	playerState = PlayerState.IDLE
	animateAction("idle")
