extends Spatial

const ROADBLOCK_SIZE = Vector3(0, 0, 10)
#const CURVE_ROT_X = 0.0872664626 # 5`
const CURVE_ROT_X = 0.01745329252 # 1` 10m/s
const SPEED_MPERS = 10

# camera controls
onready var camera_default_position = $Env/Camera.transform
onready var camera_tunnel_position = $Env/CameraTunnel.transform
var camera_movement = 0.0
var camera_target
var camera_moving = false
var camera_speed = 1

var roadBlocksResources = [
	load("res://LevelBits/RoadBlock1.tscn"),
	load("res://LevelBits/RoadBlock2.tscn"),
	load("res://LevelBits/RoadBlock3.tscn")
]

var obstacleTypes = [
	load("res://Obstacles/ObstacleBlock.tscn"),
	load("res://Obstacles/ObstacleJump.tscn"),
	load("res://Obstacles/ObstacleSlide.tscn"),
	load("res://Obstacles/ObstacleCar.tscn"),
	load("res://Obstacles/ObstacleTunnel.tscn")
]

onready var roadBlocks = $LevelRotationMidpoint/Level/RoadBlocks
onready var nextPositionPointer = $LevelRotationMidpoint/Level/NextPosition
onready var movable = $LevelRotationMidpoint
onready var player = $Player

var distance = 0

export var debug = false
var debugMessages = []

func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if !debug:
		$Debug.queue_free()
	else:
		get_tree().debug_collisions_hint = true
		
	moveCamera(camera_default_position)
	$Player.start()

func _physics_process(delta):
	if player.playerState == player.PlayerState.RUNNING:
		movable.rotate_x(-CURVE_ROT_X * delta)
		distance += SPEED_MPERS * delta
		$Gui/PlayGui.playerDistanceUpdate(distance)
	
	if camera_moving:
		camera_movement += camera_speed * delta
		$Env/Camera.transform = $Env/Camera.transform.interpolate_with(camera_target, camera_movement)
		if camera_movement >= 1.0:
			camera_moving = false

func gameOver():
	$GameOver/Popup.popup_centered()
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if debug:
		addDebug(str(event.device) + " => " + event.as_text())
	if event.is_action_pressed("exit"):
		get_tree().quit()

func gameStateChanged(newstate):
	print("hohoho")

func generateNext():
	var nextBlock: StaticBody = roadBlocksResources[randi() % roadBlocksResources.size()].instance()
	roadBlocks.add_child(nextBlock)
	
	nextBlock.translate(nextPositionPointer.translation)
	
	nextPositionPointer.rotate_x(CURVE_ROT_X)
	nextPositionPointer.translate(ROADBLOCK_SIZE)
	
	nextBlock.rotate_x(nextPositionPointer.rotation.x)
	
	return nextBlock

func cleanup():
	var blockToDelete : Node = roadBlocks.get_children()[0]
	roadBlocks.remove_child(blockToDelete)
	blockToDelete.queue_free()

func addDebug(message: String):
	debugMessages.append(message)
	if debugMessages.size() >= 5:
		debugMessages.remove(0)
	var debugMessage = ""
#	for msg in debugMessages:
#		debugMessage += "%s\n" % msg
	$Debug/DebugConsole/CenterContainer/Label.text = debugMessage


func _on_Timer_timeout():
	pass


func lowerCam():
	moveCamera(camera_tunnel_position)

func defaultCam():
	moveCamera(camera_default_position)

func moveCamera(targetPosition: Transform):
	camera_movement = 0.0
	camera_target = targetPosition
	camera_moving = true
