extends Node

var timeSinceEscape = 0
var gameStarted = false
onready var level_resource := load("res://Scenes/Levels/Level1/Level1.tscn")
onready var player_vars := get_node("/root/PlayerVariables") as PlayerVariables
var level_instance : Level1 = null

var is_mobile = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()
	$ForegroundAnimation.play("Foreground")
	$MoonAnimation.play("Moon")
	$MenuHUD/StartButton.grab_focus()
	is_mobile = (OS.get_name() == "Android")
	if (is_mobile):
		$MobileHUD.show()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("open_menu"):
		open_menu()
	pass

func new_game():
	free_level()
	player_vars.reset()
	$Music.stop()
	$ForegroundAnimation.stop(true)
	$MoonAnimation.stop(true)
	$Background.hide()
	level_instance = level_resource.instance()
	self.add_child(level_instance)
	$MenuHUD._hide_menu()
	gameStarted = true
	$MenuHUD.game_started = true
	$HUD.show()
	level_instance._start()
	pass

func open_menu():
	get_tree().paused = true
#	level_instance._pause()
	$MenuHUD/StartButton.grab_focus()
	$MenuHUD._show_menu()
	pass

func _on_MenuHUD_continue_game():
	$MenuHUD._hide_menu()
#	level_instance._continue()
	get_tree().paused = false

func _on_MenuHUD_start_game():
	new_game()
	if (get_tree().paused):
		get_tree().paused = false

func _on_MenuHUD_quit_game():
	if (gameStarted):
		gameStarted = false
		$MenuHUD.game_started = false
		free_level()
		$ForegroundAnimation.play("Foreground")
		$MoonAnimation.play("Moon")
		$Background.show()
		$MenuHUD._show_menu()
		$HUD.hide()
	else:
		get_tree().quit()

func free_level():
	if (level_instance != null):
		level_instance.free()
		level_instance = null
