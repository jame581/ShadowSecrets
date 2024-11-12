extends CanvasLayer

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS # This will make sure that the pause menu is always updated
	visible = false


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("pause_game")):
		print("Pause game action pressed")
		toggle_pause_menu()


func toggle_pause_menu() -> void:
	print("Toggle pause menu called, visible: " + str(visible))
	if (visible):
		get_tree().paused = false
		animation_player.play("fade_out")
	else:
		visible = true
		animation_player.play("fade_in")
		get_tree().paused = true


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	animation_player.play("fade_out")


func _on_restart_level_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	
	Global.restart_current_scene()


func _on_back_to_menu_button_pressed() -> void:
	Global.goto_main_menu()


func _on_animation_player_animation_finished(anim_name: String) -> void:
	print("Animation finished: " + anim_name)
	if (anim_name == "fade_out"):
		visible = false
		animation_player.stop()