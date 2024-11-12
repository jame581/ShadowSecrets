extends Node

# Define the signal
signal insanity_changed(new_insanity)

# Property to store the insanity level
var insanity: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	var insanity_sin = abs(sin(Time.get_ticks_msec() / 1000.0))
	insanity = 1.01 * insanity_sin
	print(insanity)
	emit_signal("insanity_changed", insanity)	
	RenderingServer.global_shader_parameter_set("insanity", insanity)


	#emit_signal("insanity_changed", insanity)
	#RenderingServer.global_shader_parameter_set("insanity", insanity)

	
# Function to increase insanity
func increase_insanity(amount: float) -> void:
	insanity += amount
	emit_signal("insanity_changed", insanity)
	RenderingServer.global_shader_parameter_set("insanity", insanity)
