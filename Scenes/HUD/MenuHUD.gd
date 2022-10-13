class_name MenuHUD
extends CanvasLayer

export(bool) var game_started = false
export(AudioStream) var pressed_audio_stream
export(AudioStream) var focus_audio_stream

enum HUD_ACTION {START, CONTINUE, QUIT}


signal start_game
signal continue_game
signal quit_game

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_signal()
	pass # Replace with function body.

func _show_menu():
	if (game_started):
		$ContinueButton.show()
		$StartButton.text = "Restart" 
	else:
		$ContinueButton.hide()
		$StartButton.text = "Start"
	show()
	return

func _hide_menu():
	hide()
	return

func pressed_button_action(action: int):
	$AudioStreamPlayer.stream = pressed_audio_stream
	$AudioStreamPlayer.play()

	if (action == HUD_ACTION.START):
		emit_signal("start_game")
	elif (action == HUD_ACTION.CONTINUE):
		emit_signal("continue_game")
	elif (action == HUD_ACTION.QUIT):
		emit_signal("quit_game")

func on_focus_entered():
	$AudioStreamPlayer.stream = focus_audio_stream
	$AudioStreamPlayer.play()
	pass

func connect_signal():
	$StartButton.connect("pressed", self, "pressed_button_action", [HUD_ACTION.START])
	$ContinueButton.connect("pressed", self, "pressed_button_action", [HUD_ACTION.CONTINUE])
	$QuitButton.connect("pressed", self, "pressed_button_action", [HUD_ACTION.QUIT])
	
	for children in self.get_children():
		if (children is Button):
			children.connect("focus_entered", self, "on_focus_entered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
