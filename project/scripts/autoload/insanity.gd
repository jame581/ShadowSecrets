extends Node

# Define the signal
signal insanity_changed(new_insanity)

enum insanity_level {LOW, MEDIUM, HIGH}

# Property to store the insanity level
var insanity: float = 0.0

# Function to handle insanity hit
func insanity_hit(hit_level: insanity_level) -> void:
	match hit_level:
		insanity_level.LOW:
			print("Insanity hit: LOW")
			increase_insanity(0.05)
		insanity_level.MEDIUM:
			print("Insanity hit: MEDIUM")
			increase_insanity(0.09)
		insanity_level.HIGH:
			print("Insanity hit: HIGH")
			increase_insanity(0.15)

# Function to increase insanity
func increase_insanity(amount: float) -> void:
	insanity += amount
	emit_signal("insanity_changed", insanity)
	RenderingServer.global_shader_parameter_set("insanity", insanity)


