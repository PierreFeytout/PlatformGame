extends Node2D
class_name Level1


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	pass # Replace with function body.

func _start():
	$Music.play()
	$Player._start()
	pass

func _pause():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
