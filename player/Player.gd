extends KinematicBody

export var SPEED = 5
export var SIDE_SPEED = 10
export var JUMP_SPEED = 10
export var NORMAL_HEIGHT = .7
var SLIDE_HEIGHT = NORMAL_HEIGHT / 2
var JUMP_HEIGHT = NORMAL_HEIGHT * 2

const LINE_WIDTH = 1

var motion = Vector3()

var dead = false

func _ready():
	run()

func _physics_process(delta):
	move()
	
	
func move():
	if not dead:
		motion.z = SPEED
	
		var direction = Input.get_action_strength("left") - Input.get_action_strength("right")
		translation.x = LINE_WIDTH * direction
		
		if Input.is_action_just_pressed("jump") and Utils.compare_floats(translation.y, NORMAL_HEIGHT):
			jump()
		elif Input.is_action_just_pressed("slide") and Utils.compare_floats(translation.y, NORMAL_HEIGHT):
			slide()
		
		move_and_slide(motion)


func run():
	translation.y = NORMAL_HEIGHT
	$PlayerModel/AnimationPlayer.queue("run")


func jump():
	translation.y = JUMP_HEIGHT
	$Timers/JumpTimer.start()
	$PlayerModel/AnimationPlayer.play("jump")

func _on_JumpTimer_timeout():
	$PlayerModel/AnimationPlayer.play_backwards("jump")
	run()


func slide():
	translation.y = SLIDE_HEIGHT
	$Timers/SlideTimer.start()
	$PlayerModel/AnimationPlayer.play("slide")

func _on_SlideTimer_timeout():
	$PlayerModel/AnimationPlayer.play_backwards("slide")
	run()


func hit():
	dead = true
	$PlayerModel/AnimationPlayer.play("die")
	get_tree().call_group("game", "gameOver")


