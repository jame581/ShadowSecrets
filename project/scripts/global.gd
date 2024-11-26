extends Node

signal map_changed(new_map_path: String)

var current_scene = null

var current_path : String = ""

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	LoadingScreen.loading_screen_shown.connect(_on_loading_screen_shown)
	LoadingScreen.loading_screen_hidden.connect(_on_loading_screen_hidden)


func get_game_version():
	return ProjectSettings.get_setting("application/config/version")

func goto_main_menu():
	goto_scene("res://maps/main_menu.tscn")

func goto_scene(path):
	current_path = path
	LoadingScreen.show_loading_screen()	

func restart_current_scene():
	goto_scene(current_scene.scene_file_path)

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene.
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
	map_changed.emit(current_scene.scene_file_path)
	await LoadingScreen.hide_loading_screen()
	get_tree().paused = false

func _on_loading_screen_hidden():
	# This function will be called when the loading screen is hidden
	# and the new scene is ready to be displayed.
	# Add any code you need to execute after the scene change.
	pass

func _on_loading_screen_shown():
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", current_path)
