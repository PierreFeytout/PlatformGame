extends Node2D
class_name Level1

var player_instance : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	var player_resource := load("Scenes/Player/Player.tscn")
	player_instance = player_resource.instance()
	self.add_child(player_instance)
	pass

func _start():
	player_instance.position = $Technical/StartPosition.position
	$Audio/Music.play()
	var cam = player_instance.get_child(1) as Camera2D
	cam.global_position.y = 270
	cam.limit_right = $Technical/EndPosition.global_position.x
	player_instance._start()
	pass

func _pause():
	player_instance.set_physics_process(false)

func _continue():
	player_instance.set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
