class_name HUD
extends CanvasLayer

export(bool) var game_started = false

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
	show()
	return

func _hide_menu():
	hide()
	return

func pressed_button_action(action: int):
	if (action == HUD_ACTION.START):
		emit_signal("start_game")
	elif (action == HUD_ACTION.CONTINUE):
		emit_signal("continue_game")
	elif (action == HUD_ACTION.QUIT):
		emit_signal("quit_game")

func connect_signal():
	$StartButton.connect("pressed", self, "pressed_button_action", [HUD_ACTION.START])
	$ContinueButton.connect("pressed", self, "pressed_button_action", [HUD_ACTION.CONTINUE])
	$QuitButton.connect("pressed", self, "pressed_button_action", [HUD_ACTION.QUIT])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
