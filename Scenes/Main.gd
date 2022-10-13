extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$ForegroundAnimation.play("Foreground")
	$MoonAnimation.play("Moon")
	if (!Game.is_mobile):
		$Music.play()
	$MenuHUD._show_menu()
