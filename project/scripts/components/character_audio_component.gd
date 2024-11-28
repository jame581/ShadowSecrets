extends Node2D

@onready var audio_stream: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")


func play_audio(audio: AudioStream) -> void:
	# print("Playing audio called")
	# if audio != null:
	# 	return
	
	# if audio == audio_stream.stream and audio_stream.playing:
	# 	return

	# print("Playing audio called: " + str(audio))
	audio_stream.stream = audio
	audio_stream.play()
 
func stop_audio() -> void:
	audio_stream.stop()

func play_random_audio(audio_list: Array) -> void:
	var random_index = randi() % audio_list.size()
	play_audio(audio_list[random_index])

func _on_audio_stream_player_2d_finished() -> void:
	pass