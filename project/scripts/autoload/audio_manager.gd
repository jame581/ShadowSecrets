extends Node2D

@export_group("Audio Manager")
@export var audio_enabled: bool = true
@export var intro_audio: AudioStream = preload("res://assets/audio/intro.wav")
@export var main_menu: AudioStream = preload("res://assets/audio/level_draft.wav")
@export var outro_audio: AudioStream = preload("res://assets/audio/intro.wav")
@export var main_game: AudioStream

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_player.stream = main_menu
	Global.map_changed.connect(_on_map_changed)
	if audio_enabled:
		audio_player.play()
		pass


func set_sound_enabled(enabled: bool) -> void:
	audio_enabled = enabled
	if audio_enabled:
		audio_player.play()
	else:
		audio_player.stop()

func _on_map_changed(map_name: String) -> void:
	if !audio_enabled:
		return

	if map_name == "res://maps/main_menu.tscn":
		audio_player.stream = main_menu
		audio_player.play()
	elif map_name == "res://maps/intro_scene.tscn":
		audio_player.stream = intro_audio
		audio_player.play()
	elif map_name == "res://maps/outro_scene.tscn":
		audio_player.stream = outro_audio
		audio_player.play()
	else:
		audio_player.stop()
		audio_player.stream = null