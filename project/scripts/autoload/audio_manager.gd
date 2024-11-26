extends Node2D

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var audio_enabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if audio_enabled:
		audio_player.play()


func set_sound_enabled(enabled: bool) -> void:
	audio_enabled = enabled
	if audio_enabled:
		audio_player.play()
	else:
		audio_player.stop()