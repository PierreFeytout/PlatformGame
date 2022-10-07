extends Node

var timeSinceEscape = 0
var gameStarted = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("open_menu"):
		open_menu()
	pass

func new_game():
	$Level1._start()
	$HUD.hide()
	pass

func open_menu():
	$Level1._pause()
	$HUD.show()
	pass

func _on_StartButton_pressed():
	new_game()
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
	pass # Replace with function body.
