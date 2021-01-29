extends Spatial

const ROADBLOCK_SIZE = Vector3(0, 0, 10)
#const CURVE_ROT_X = 0.0872664626 # 5`
const CURVE_ROT_X = 0.01745329252 # 1` 10m/s
const SPEED_MPERS = 10

var speed = 1

# camera controls
onready var camera = $Env/Camera
onready var cameraDefaultPosition = $Env/CamPosDefault.transform
onready var cameraTunnelPosition = $Env/CamPosTunnel.transform
const CAMERA_MOVEMENT_SPEED = 1
var cameraMovement = 0.0
var cameraTarget
var cameraMoving = false

var roadBlocksResources = [
	load("res://LevelBits/RoadBlock1.tscn"),
	load("res://LevelBits/RoadBlock2.tscn"),
	load("res://LevelBits/RoadBlock3.tscn")
]

onready var roadBlocks = $LevelRotationMidpoint/Level/RoadBlocks
onready var nextPositionPointer = $LevelRotationMidpoint/Level/NextPosition
onready var movable = $LevelRotationMidpoint
onready var player = $Player

var distance = 0
var blockCounter = 0

export var debug = false
var debugMessages = []

func _ready():
	randomize()
	
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if !debug:
		$Debug.queue_free()
	else:
		get_tree().debug_collisions_hint = true
	moveCamera(cameraDefaultPosition)
	$Player.start()

func _physics_process(delta):
	if player.playerState == player.PlayerState.RUNNING:
		movable.rotate_x(-CURVE_ROT_X * delta * speed)
		distance += SPEED_MPERS * delta * speed
		$Gui/PlayGui.playerDistanceUpdate(distance)
	
	if cameraMoving:
		cameraMovement += CAMERA_MOVEMENT_SPEED * delta
		camera.transform = camera.transform.interpolate_with(cameraTarget, cameraMovement)
		if cameraMovement >= 1.0:
			cameraMoving = false

func gameOver():
	$GameOver/Popup.popup_centered()
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if debug:
		addDebug(str(event.device) + " => " + event.as_text())
	if event.is_action_pressed("exit"):
		get_tree().quit()
	if event.is_action_pressed("diffPlus"):
		get_tree().call_group("level", "updateDifficultyBy", +1)
	if event.is_action_pressed("diffMinus"):
		get_tree().call_group("level", "updateDifficultyBy", -1)

func gameStateChanged(newstate):
	print("hohoho")

func generateNext() -> StaticBody:
	blockCounter += 1
	
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
	moveCamera(cameraTunnelPosition)

func defaultCam():
	moveCamera(cameraDefaultPosition)

func moveCamera(targetPosition: Transform):
	cameraMovement = 0.0
	cameraTarget = targetPosition
	cameraMoving = true
