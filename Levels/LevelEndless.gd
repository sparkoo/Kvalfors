extends "res://Levels/LevelTemplate.gd"

const ROADBLOCK_SIZE = Vector3(0, 0, 10)

onready var roadBlocks = $RoadBlocks

func _ready():
	for n in range(5):
		generateNext()

func _on_GenNext_body_entered(body: KinematicBody):
	generateNext()
	moveGenDetector()
	cleanup()

func generateNext():
	print("generating")
	var nextBlock: StaticBody = load("res://LevelBits/RoadBlock.tscn").instance()
	roadBlocks.add_child(nextBlock)
	nextBlock.translate($Env/NextPosition.translation)
	$Env/NextPosition.translate(ROADBLOCK_SIZE)

func moveGenDetector():
	$Env/GenNextDetector.translate(ROADBLOCK_SIZE)

func cleanup():
	var blockToDelete : Node = roadBlocks.get_children()[0]
	roadBlocks.remove_child(blockToDelete)
	blockToDelete.queue_free()
