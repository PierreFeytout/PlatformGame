class_name BaseLevel
extends Node2D

var player_instance : Player
var hud_instance

func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	var player_resource := load("Scenes/Player/Player.tscn")
	player_instance = player_resource.instance()
	self.add_child(player_instance)

	var hud_resource = load("Scenes/HUD/HUD.tscn")
	hud_instance = hud_resource.instance()
	self.add_child(hud_instance)

	_start()
	Game.is_in_game = true

func _start():
	pass

func _process(delta):
	if Input.is_action_pressed("open_menu"):
		open_menu()

func open_menu():
	if (Game.is_paused):
		Game.unload_menu()
	else:
		Game.load_menu()
	Game.pause()
