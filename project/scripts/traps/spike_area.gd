extends InteractableDevice
class_name SpikeArea

enum activation_direction {LEFT, RIGHT}

@export_group("Spike Area")
@export var autostart: bool = true
@export var spikes: Array[Spike] = []
@export var timer_duration: float = 3.0
@export var direction : activation_direction = activation_direction.LEFT

@onready var timer: Timer = $Timer

# Index of the current spike
var spike_index: int = 0

# Disable autostart for all spikes before entering the tree
func _enter_tree( ):
	for spike in spikes:
		spike.autostart = false		

# Set the timer duration for all spikes and start own timer
func _ready():
	for spike in spikes:
		spike.timer.wait_time = timer_duration

	if autostart:
		# print("autostart")
		enable()

func _interact():
	toggle()

func enable():
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start()

func disable():
	timer.stop()

func toggle():
	enabled = !enabled
	if enabled:
		enable()
	else:
		disable()

# Start the timer of the next spike
func _on_timer_timeout():
	if direction == activation_direction.LEFT:
		spikes[spike_index].timer.start()
		spike_index += 1
	elif direction == activation_direction.RIGHT:
		spikes[spikes.size()-1-spike_index].timer.start()
		spike_index += 1

	if spike_index >= spikes.size():
		timer.stop()
