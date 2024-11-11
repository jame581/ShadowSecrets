extends MarginContainer

# Paths to the levels
@export_category("Paths to levels")
@export var level_paths: Array[String] = [
	"res://maps/level_prototype.tscn",
	"res://maps/mask_test.tscn",
	"res://maps/test_scene.tscn",
	"res://maps/game_world.tscn",
]

@onready var version_label: Label = get_node("HBoxContainer/VBoxMenu/VersionLabel")

var level_selected = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	version_label.text = "Version: " + ProjectSettings.get_setting("application/config/version")
	
	if level_paths.size() > 0:
		level_selected = level_paths[0]
	else:
		push_error("No levels found in the level_paths array")


func _on_start_game_button_pressed() -> void:
	Global.goto_scene("res://maps/game_world.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_item_list_item_selected(index: int) -> void:
	# Select the level based on the index
	if index < level_paths.size():
		level_selected = level_paths[index]
	else:
		push_error("Index out of bounds, index: " + str(index) + " level_paths.size(): " + str(level_paths.size()))
		level_selected = level_paths[0]

func _on_start_selected_level_button_pressed() -> void:
		Global.goto_scene(level_selected)
