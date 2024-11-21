extends Control

signal loading_screen_hidden()
signal loading_screen_shown()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var wating_to_hide: bool = false


func _ready() -> void:
	print("Loading screen ready")
	visible = false
	canvas_layer.visible = false


func show_loading_screen() -> void:
	print("Showing loading screen")
	animation_player.play("fade_in")
	visible = true
	canvas_layer.visible = true
	wating_to_hide = false


func hide_loading_screen() -> void:
	print("Hiding loading screen")
	animation_player.play_backwards("fade_in")
	wating_to_hide = true


func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		if wating_to_hide:
			visible = false
			wating_to_hide = false
			canvas_layer.visible = false
			loading_screen_hidden.emit()
		else:
			loading_screen_shown.emit()