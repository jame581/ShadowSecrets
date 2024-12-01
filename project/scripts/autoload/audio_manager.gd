extends Node2D

@export_group("Audio Manager")
@export var audio_enabled: bool = true
@export var intro_audio: AudioStream = preload("res://assets/audio/intro.wav")
@export var main_menu: AudioStream = preload("res://assets/audio/level_draft.wav")
@export var outro_audio: AudioStream = preload("res://assets/audio/stellarsecrets_mx_outro.wav")
@export var main_game: AudioStream = preload("res://assets/audio/stellarsecrets_mx_level.wav")

# @onready var audio_background: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_buttons: AudioStreamPlayer2D = $AudioStreamButtons
@onready var audio_background: AudioStreamPlayer = $BackgroundMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS # This will make sure that the pause menu is always updated
	audio_background.stream = main_menu
	
	_on_map_changed(Global.current_path)
	Global.map_changed.connect(_on_map_changed)
	if audio_enabled:
		audio_background.play()
		pass

func play_button_sound() -> void:
	if audio_enabled:
		audio_buttons.play()

func set_sound_enabled(enabled: bool) -> void:
	audio_enabled = enabled
	if audio_enabled:
		audio_background.play()
	else:
		audio_background.stop()

func _on_map_changed(map_name: String) -> void:
	if !audio_enabled:
		return

	if map_name == "res://maps/main_menu.tscn":
		audio_background.stream = main_menu
		audio_background.play()
	elif map_name == "res://maps/intro_scene.tscn":
		audio_background.stream = intro_audio
		audio_background.play()
	elif map_name == "res://maps/outro_scene.tscn":
		audio_background.stream = outro_audio
		audio_background.play()
	elif map_name == "res://maps/game_world.tscn":
		audio_background.stream = main_game
		audio_background.play()
	else:
		audio_background.stop()
		audio_background.stream = null

func _on_audio_stream_player_2d_finished() -> void:
	if audio_enabled:
		audio_background.play()
	pass