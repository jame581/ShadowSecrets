extends Node2D
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Timer_timeout():
	$AnimationPlayer.play("enable")
