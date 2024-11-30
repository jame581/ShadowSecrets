extends Node

# Signals
signal game_started
signal game_paused(is_paused: bool)
signal game_is_over
signal god_mode_changed(is_god: bool)

@onready var cheat_timer = $CheatTimer

var is_god_mode : bool = false

var cheat_codes = [null]
var god_cheat = ["K", "O", "Z", "Y"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cheat_timer.start()


func game_over() -> void:
	game_is_over.emit()


func set_god_mode(is_god: bool) -> void:
	is_god_mode = is_god
	god_mode_changed.emit(is_god)


func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		if cheat_timer.is_stopped():
			cheat_timer.start()
			
		if event.keycode == KEY_K:
			cheat_codes.append("K")
		if event.keycode == KEY_O:
			cheat_codes.append("O")
		if event.keycode == KEY_Z:
			cheat_codes.append("Z")
		if event.keycode == KEY_Y:
			cheat_codes.append("Y")


func _on_cheat_timer_timeout() -> void:
	if cheat_codes.size() > 0:
		print("Cheat: ", cheat_codes)
		if cheat_codes == god_cheat:
			set_god_mode(!is_god_mode)
			cheat_codes.clear()
	
	cheat_codes.clear()
	print("Cheat codes cleared")
	print("God mode is now: ", is_god_mode)
	cheat_timer.stop()

func _trigger_game_end(is_good_ending: bool) -> void:
	#TODO(Honza): Implement game ending
	print("Good ending? ", is_good_ending)
	pass

func _mark_section_finished(section_name: ProximityTrigger.section_type) -> void:
	#TODO(Jakub): Implement section finished
	print("Section finished: ", section_name)
	pass