class_name MenuHUD
extends CanvasLayer

export(AudioStream) var pressed_audio_stream
export(AudioStream) var focus_audio_stream

enum HUD_ACTION {START, CONTINUE, QUIT}

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	if (Game.is_in_game):
		$Node/ContinueButton.grab_focus()
	else:
		$Node/StartButton.grab_focus()
	pass # Replace with function body.

func _show_menu():
	$AnimationPlayer.play_backwards("appear")
	connect_signal()
	show()
	if (Game.is_in_game):
		$Node/ContinueButton.show()
		$Node/StartButton.text = "Restart" 
	else:
		$Node/ContinueButton.hide()
		$Node/StartButton.text = "Start"
	return

func pressed_button_action(action: int):
	$AudioStreamPlayer.stream = pressed_audio_stream
	$AudioStreamPlayer.play()

	if (action == HUD_ACTION.START):
		new_game()
	elif (action == HUD_ACTION.CONTINUE):
		continue_game()
	elif (action == HUD_ACTION.QUIT):
		quit_game()

func on_focus_entered():
	$AudioStreamPlayer.stream = focus_audio_stream
	$AudioStreamPlayer.play()

func connect_signal():
	$Node/StartButton.connect("pressed", self, "pressed_button_action", [HUD_ACTION.START])
	$Node/ContinueButton.connect("pressed", self, "pressed_button_action", [HUD_ACTION.CONTINUE])
	$Node/QuitButton.connect("pressed", self, "pressed_button_action", [HUD_ACTION.QUIT])
	
	for children in self.get_children():
		if (children is Button):
			children.connect("focus_entered", self, "on_focus_entered")

func new_game():
	$AnimationPlayer.play("appear")
	yield($AnimationPlayer,"animation_finished")
	Game.unload_menu()
	PlayerVariables.reset()
	SceneTransition.change_scene("res://Scenes/Levels/Level1/Level1.tscn")
	if (Game.is_paused):
		Game.pause()
	pass

func continue_game():
	Game.pause()
	$AnimationPlayer.play("appear")
	yield($AnimationPlayer,"animation_finished")
	Game.unload_menu()

func quit_game():
	if (Game.is_in_game):
		$AnimationPlayer.play("appear")
		yield($AnimationPlayer,"animation_finished")
		Game.goto_main_menu()
	else:
		Game.quit()
