extends InteractableDevice
class_name PowerGenerator

@export var interactable_devices: Array[InteractableDevice] = []
@export_group("Dialog Setup")
@export var dialog_text: String = "Hello, world!"
@export var dialog_wait_time: float = 5.0

@onready var animation: AnimationPlayer = $AnimationPlayer

var phase : int = 0

func _ready():
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
		show_dialog()

func delayed_start():
	if not enabled:
		await get_tree().create_timer(1.0).timeout
		set_state(true)

func show_dialog() -> void:
	var dialog_data: Dictionary = {
		"text": dialog_text,
		"wait_time": dialog_wait_time,
		"hide_dialog_after": true
	}
	DialogManager.emit_signal("show_dialog", dialog_data)