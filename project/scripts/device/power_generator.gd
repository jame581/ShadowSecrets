extends InteractableDevice
class_name PowerGenerator

@export var interactable_devices: Array[InteractableDevice] = []

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var phase : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Triggers the outputs of all connected interactable devices.
func trigger_outputs():
	for interactable_device in interactable_devices:
		interactable_device._interact()

func _interact():
	phase += 1
	# If the phase is less than or equal to 3, play the sequence animation
	if phase <= 3:
		animation.play("sequence"+str(phase))

# In case of power generator this is called from animation player
func set_state(state: bool):
	enabled = state
	if enabled:
		Power.give_me_power()
		trigger_outputs()

func delayed_start():
	if not enabled:
		await get_tree().create_timer(2.0).timeout
		set_state(true)
