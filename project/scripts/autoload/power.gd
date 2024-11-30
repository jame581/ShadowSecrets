extends Node

signal power_activated()

var power: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Function to handle insanity hit
func give_me_power() -> void:
	power = true
	emit_signal("power_activated")
	#print("Power activated")
