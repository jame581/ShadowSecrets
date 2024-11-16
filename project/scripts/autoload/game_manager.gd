extends Node

# Signals
signal game_started
signal game_paused(is_paused: bool)
signal game_is_over


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func game_over() -> void:
	game_is_over.emit()
