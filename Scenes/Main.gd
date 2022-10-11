extends Node

var timeSinceEscape = 0
var gameStarted = false

var is_mobile = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD/StartButton.grab_focus()
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
	$Level1._start()
	$HUD._hide_menu()
	$HUD.game_started = true
	pass

func open_menu():
	$Level1._pause()
	$HUD/StartButton.grab_focus()
	$HUD._show_menu()
	pass

func _on_ContinueButton_pressed():
	$HUD._hide_menu()
	$Level1._continue()
	pass
	
func _on_StartButton_pressed():
	new_game()
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
	pass # Replace with function body.
