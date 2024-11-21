extends InteractableDevice
class_name PANIC

#Paranoid Android Network, Inefficient and Clumsy

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create a timer
	var timer = Timer.new()
	timer.wait_time = 10.0
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	add_child(timer)
	timer.start()

func _interact():
	enabled = not enabled

	if	enabled:
		$AnimationPlayer.play("enable")
	else:
		$AnimationPlayer.play("disable")

func _on_Timer_timeout():
	pass
	#$AnimationPlayer.play("enable")