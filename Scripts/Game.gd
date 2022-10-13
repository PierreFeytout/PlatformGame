extends Node
onready var is_mobile = (OS.get_name() == "Android")
onready var menu_resource = preload("res://Scenes/HUD/MenuHUD.tscn")
onready var scene_tree = get_tree()
var current_scene = null
var menu_scene : MenuHUD = null
var is_in_game = false
var is_paused = false setget , getIsPaused

func getIsPaused() -> bool:
	return scene_tree.paused

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_main_menu():
	is_in_game = false
	Game.unload_menu()
	goto_scene("res://Scenes/Main.tscn")

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path: String):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().current_scene = current_scene
	
func load_menu():
	menu_scene = menu_resource.instance()
	get_tree().root.add_child(menu_scene)
	menu_scene._show_menu()

func unload_menu():
	if (menu_scene):
		menu_scene.queue_free()
		menu_scene = null

func pause():
	scene_tree.paused = !scene_tree.paused

func quit():
	scene_tree.quit()
