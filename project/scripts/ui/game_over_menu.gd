extends CanvasLayer

@export_category("Game Over Menu Settings")
@export var animation_speed: float = 2.0

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS # This will make sure that the pause menu is always updated
	visible = false
	GameManager.game_is_over.connect(handle_game_over)


func _on_last_checkpoint_button_pressed() -> void:
	pass # Replace with function body.


func _on_restart_level_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	
	Global.restart_current_scene()


func _on_back_to_menu_button_pressed() -> void:
	get_tree().paused = false
	Global.goto_main_menu()


func _on_animation_player_animation_finished(anim_name: String) -> void:
	print("Animation finished: " + anim_name)
	if (anim_name == "fade_out"):
		visible = false
		animation_player.stop()


func handle_game_over() -> void:
	print("Game over signal received")
	visible = true
	animation_player.play("fade_in", -1, animation_speed)
	get_tree().paused = true