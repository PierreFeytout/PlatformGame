extends BaseLevel
class_name Level1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _start():
	player_instance.position = $Technical/StartPosition.position
	$Audio/Music.play()
	var cam = player_instance.get_child(1) as Camera2D
	cam.global_position.y = 270
	cam.limit_right = $Technical/EndPosition.global_position.x
	player_instance._start()

func _pause():
	player_instance.set_physics_process(false)

func _continue():
	player_instance.set_physics_process(true)
