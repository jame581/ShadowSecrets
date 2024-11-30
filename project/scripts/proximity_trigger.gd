@tool
extends InteractableDevice
class_name ProximityTrigger

@export var interactable_devices: Array[InteractableDevice] = []
@export var single_interaction: bool = true
@export var radius: float = 45.0:
	set(value):
		if has_node("Area2D"):
			$Area2D/CollisionShape2D.get_shape().radius = value		
	get:
		return $Area2D/CollisionShape2D.get_shape().radius

@onready var collision: CollisionShape2D = $Area2D/CollisionShape2D

# Called when the node is added to the scene.
func _ready():
	if Engine.is_editor_hint():
		update_text()
	else:
		$RichTextLabel.visible = false

	update_text()
		
# Sets the state of the device and updates its visual state.
func set_state(state: bool):
	enabled = state
	update_text()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if	enabled:
			trigger_outputs()
		else:
			call_deferred("set_state", not enabled)
			update_text()

		if single_interaction:
			collision.disabled = true

# Triggers the outputs of all connected interactable devices.
func trigger_outputs():
	for interactable_device in interactable_devices:
		interactable_device._interact()

func update_text():
	if Engine.is_editor_hint():
		if enabled:
			$RichTextLabel.text = "Proximity: \n Enabled"
		else:
			$RichTextLabel.text = "Proximity: \n Disabled"

func _on_enabled_changed():
	update_text()