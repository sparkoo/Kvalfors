extends Spatial

const ROADBLOCK_SIZE = Vector3(0, 0, 10)
var roadBlockResource = load("res://LevelBits/RoadBlock.tscn")

onready var roadBlocks = $Level/RoadBlocks
onready var nextPositionPointer = $Level/NextPosition
onready var movable = $Level
onready var player = $Player

export var SPEED = 5

var distance = 0

func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _process(delta):
	if player.playerState == player.PlayerState.RUNNING:
		movable.translate(Vector3(0, 0, SPEED * delta * -1))
		distance += SPEED * delta
		$Gui/PlayGui.playerDistanceUpdate(distance)

func gameOver():
	$GameOver/Popup.popup_centered()
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()

func gameStateChanged(newstate):
	print("hohoho")

func generateNext():
	var nextBlock: StaticBody = roadBlockResource.instance()
	roadBlocks.add_child(nextBlock)
	nextBlock.translate(nextPositionPointer.translation)
	nextPositionPointer.translate(ROADBLOCK_SIZE)

func cleanup():
	var blockToDelete : Node = roadBlocks.get_children()[0]
	roadBlocks.remove_child(blockToDelete)
	blockToDelete.queue_free()
