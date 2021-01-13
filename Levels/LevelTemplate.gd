extends Spatial

const ROADBLOCK_SIZE = Vector3(0, 0, 10)
#const CURVE_ROT_X = 0.0872664626 # 5`
const CURVE_ROT_X = 0.01745329252 # 1`
const SPEED_MPERS = 10

var roadBlockResource = load("res://LevelBits/RoadBlock.tscn")

onready var roadBlocks = $LevelRotationMidpoint/Level/RoadBlocks
onready var nextPositionPointer = $LevelRotationMidpoint/Level/NextPosition
onready var movable = $LevelRotationMidpoint
onready var player = $Player

var distance = 0

var debug = true
var debugMessages = []

func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if !debug:
		$Debug.queue_free()
	else:
		get_tree().debug_collisions_hint = true
	$Player.start()

func _physics_process(delta):
	if player.playerState == player.PlayerState.RUNNING:
		movable.rotate_x(-CURVE_ROT_X * delta)
		distance += SPEED_MPERS * delta
		$Gui/PlayGui.playerDistanceUpdate(distance)

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
	var nextBlock: StaticBody = roadBlockResource.instance()
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
