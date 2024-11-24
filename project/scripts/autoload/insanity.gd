extends Node

# Define the signal
signal insanity_changed(new_insanity)

# Define an enum for insanity levels
enum insanity_level {LOW, MEDIUM, HIGH}

# Property to store the insanity level
var insanity: float = 0.0

# Timer to increase insanity level
@onready var insanity_timer: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    # Set up the timer
    insanity_timer.wait_time = 0.2
    insanity_timer.autostart = true
    insanity_timer.one_shot = false
    add_child(insanity_timer)
    insanity_timer.connect("timeout", Callable(self, "_on_insanity_timer_timeout"))

# Function to handle insanity hit
func insanity_hit(hit_level: insanity_level) -> void:
    match hit_level:
        insanity_level.LOW:
            print("Insanity hit: LOW")
            increase_insanity(0.10)
        insanity_level.MEDIUM:
            print("Insanity hit: MEDIUM")
            increase_insanity(0.20)
        insanity_level.HIGH:
            print("Insanity hit: HIGH")
            increase_insanity(0.30)

# Private function to increase insanity
func increase_insanity(amount: float) -> void:
    if (insanity + amount) < 0.0:
        return

    insanity += amount
    emit_signal("insanity_changed", insanity)
    RenderingServer.global_shader_parameter_set("insanity", insanity)

# Function called when the timer times out
func _on_insanity_timer_timeout() -> void:
    increase_insanity(-0.02)  # Increase insanity by a small amount each time
