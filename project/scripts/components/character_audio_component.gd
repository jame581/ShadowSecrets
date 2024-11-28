extends Node2D

class_name CharacterAudioComponent

@onready var audio_stream: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")
@onready var timer: Timer = get_node("Timer")

var default_pitch: float = 1.0
var audio_volume: float = 0.0

func _ready() -> void:
	default_pitch = audio_stream.pitch_scale

func play_audio(audio: AudioStream) -> void:
	audio_stream.pitch_scale = default_pitch
	if audio != audio_stream.stream:
		print("Set audio audio")
		audio_stream.stream = audio
		timer.stop()
		audio_stream.play()
	else:		
		timer.wait_time = audio.get_length()
		if timer.time_left <= 0:
			timer.start()
			audio_stream.play()
	
 
func stop_audio() -> void:
	audio_stream.stop()
	timer.stop()

func play_random_audio(audio_list: Array) -> void:
	audio_stream.pitch_scale = default_pitch
	var random_index = randi() % audio_list.size()
	play_audio(audio_list[random_index])

func play_with_random_pitch(audio: AudioStream, min_pitch: float, max_pitch: float) -> void:
	audio_stream.pitch_scale = randf_range(min_pitch, max_pitch)
	if audio != audio_stream.stream:
		print("Set audio audio")
		audio_stream.stream = audio
		timer.stop()
		print("Play with random pitch: ", audio_stream.pitch_scale)
		audio_stream.play()
	else:		
		timer.wait_time = audio.get_length()
		if timer.time_left <= 0:
			timer.start()
			audio_stream.play()
			print("Play with random pitch: ", audio_stream.pitch_scale)

func _on_audio_stream_player_2d_finished() -> void:
	pass

func is_playing() -> bool:
	return audio_stream.playing

func set_audio_volume(volume: float) -> void:
	audio_stream.volume_db = volume
	audio_volume = volume

func get_audio_volume() -> float:
	return audio_volume