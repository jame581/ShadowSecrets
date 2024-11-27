extends Node

# Define the signal
signal insanity_changed(new_insanity)

# Define an enum for insanity levels
enum insanity_level {LOW, MEDIUM, HIGH}

# Property to store the insanity level
var insanity: float = 0.0

# Timer to increase insanity level
@onready var insanity_timer: Timer = Timer.new()

@export var insanity_min: float = 0.0
@export var insanity_max: float = 1.0

var insanity_hit_low: float = 0.05
var insanity_hit_medium: float = 0.08
var insanity_hit_high: float = 0.15

var camera_shaker: AnimationPlayer = null
@onready var screen_effects: AnimationPlayer = $ScreenEffects

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
		camera_shaker = get_viewport().get_camera_2d().get_node("CameraShaker")

# Function to handle insanity hit
func insanity_hit(hit_level: insanity_level) -> void:
	var insanity_hit: float = 0.0

	match hit_level:
		insanity_level.LOW:
			insanity_hit = insanity_hit_low
		insanity_level.MEDIUM:
			insanity_hit = insanity_hit_medium
		insanity_level.HIGH:
			insanity_hit = insanity_hit_high

	increase_insanity(insanity_hit)

	# Shake the camera if the insanity is high
	if insanity >= 0.75:
		shake_camera()

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

func shake_camera():
	if camera_shaker != null:
		camera_shaker.play("shake_high")

func hit_effect():
	if screen_effects != null:
		screen_effects.play("hit")
