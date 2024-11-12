extends Node2D
class_name SpikeArea

enum activation_direction {LEFT, RIGHT}

@export_group("Spike Area")
@export var spikes: Array[Spike] = []
@export var timer_duration: float = 3.0
@export var direction : activation_direction = activation_direction.LEFT


@onready var timer: Timer = $Timer

var spike_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for spike in spikes:
		spike.timer.wait_time = timer_duration

	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	if direction == activation_direction.LEFT:
		spikes[spike_index].timer.start()
		spike_index += 1
	elif direction == activation_direction.RIGHT:
		spikes[spikes.size()-1-spike_index].timer.start()
		spike_index += 1

	if spike_index >= spikes.size():
		timer.stop()
