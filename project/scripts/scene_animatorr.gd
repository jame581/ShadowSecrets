extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Power.connect("power_activated", Callable(self, "_on_power_activated"))
	play("blinking")


func _on_power_activated():
	print("Power activated")
	play("enable_lights")
	await get_tree().create_timer(2.0).timeout
	play("RESET")