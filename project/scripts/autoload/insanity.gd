extends Node

# Define the signal
signal insanity_changed(new_insanity)

# Define an enum for insanity levels
enum insanity_level {LOW, MEDIUM, HIGH, IK}

# Property to store the insanity level
var insanity: float = 0.0

# Timer to increase insanity level
@onready var insanity_timer: Timer = Timer.new()

@export var insanity_min: float = 0.0
@export var insanity_max: float = 1.0

var insanity_change_low: float = 0.10
var insanity_change_medium: float = 0.20
var insanity_change_high: float = 0.30
var insanity_change_ik: float = 2.0

var camera_shaker: AnimationPlayer = null
@onready var insanity_effects_player: AnimationPlayer = $InsanityEffects

# Reference to the AudioStreamPlayer2D node
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set up the timer
	insanity_timer.wait_time = 0.2
	insanity_timer.autostart = true
	insanity_timer.one_shot = false
	add_child(insanity_timer)
	insanity_timer.connect("timeout", Callable(self, "_on_insanity_timer_timeout"))

	Global.map_changed.connect(Callable(self, "_on_map_changed"))

	# Get the camera shaker, if available (its not in main menu)
	if	get_viewport() && get_viewport().get_camera_2d():
		# print("get_viewport: " + str(get_viewport()), "get_camera_2d: " + str(get_viewport().get_camera_2d()), "get_node: " + str(get_viewport().get_camera_2d().get_child("CameraShaker")))
		camera_shaker = get_viewport().get_camera_2d().get_node_or_null("CameraShaker")

# Function to handle insanity hit
func insanity_hit(hit_level: insanity_level) -> void:
	var insanity_change: float = 0.0

	match hit_level:
		insanity_level.LOW:
			insanity_change = insanity_change_low
		insanity_level.MEDIUM:
			insanity_change = insanity_change_medium
		insanity_level.HIGH:
			insanity_change = insanity_change_high
		insanity_level.IK:
			insanity_change = insanity_change_ik

	increase_insanity(insanity_change)

	# Shake the camera if the insanity is high
	if insanity >= 0.70:
		play_near_death_effect()

	# Play the hit effect
	hit_effect()

# Private function to increase insanity
func increase_insanity(amount: float) -> void:
	if GameManager.is_god_mode:
		insanity = 0.0
		return

	if (insanity + amount) < 0.0:
		return

	insanity += amount

	# notify the change
	on_insanity_changed(insanity)

# Function called when the timer times out
func _on_insanity_timer_timeout() -> void:
	if insanity < 0.7:
		increase_insanity(-0.007) 
	elif insanity < 1.2:
		increase_insanity(-0.01)
	elif insanity < 2.0:
		increase_insanity(-0.02)
	
func on_insanity_changed(new_insanity: float) -> void:
	print("Insanity changed to: ", new_insanity)
	emit_signal("insanity_changed", new_insanity)
	RenderingServer.global_shader_parameter_set("insanity", clamp(new_insanity, insanity_min, insanity_max))

# Function to handle map change
func _on_map_changed(_new_map_path: String):
	insanity = 0.0
	on_insanity_changed(insanity)

func play_near_death_effect():
	if camera_shaker != null:
		camera_shaker.play("shake_high")
		print("Play camera shake")
	
	# if insanity_effects_player != null:
	# 	insanity_effects_player.play("near_death")
	# 	print("Play near death effect")

	if audio_player != null:
		audio_player.play()
		await get_tree().create_timer(2.0).timeout
		audio_player.stop()

func hit_effect():
	if insanity_effects_player != null:
		insanity_effects_player.play("hit")
