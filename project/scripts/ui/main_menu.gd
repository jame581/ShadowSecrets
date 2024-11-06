extends MarginContainer

@onready var version_label: Label = get_node("HBoxContainer/VBoxMenu/VersionLabel")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	version_label.text = "Version: " + ProjectSettings.get_setting("application/config/version")


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://maps/level_prototype.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
