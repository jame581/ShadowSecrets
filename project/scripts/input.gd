extends InteractableDevice
class_name InputDevice

@export var interactable_devices: Array[InteractableDevice] = []
@export var single_interaction: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $InteractionArea/CollisionShape2D

# Called when the node is added to the scene.
func _ready():
	if sprite.material is ShaderMaterial:
		sprite.material = sprite.material.duplicate()
	if enabled:
		set_state(true)

# Sets the state of the device and updates its visual state.
func set_state(state: bool):
	enabled = state
	update_visual_state()
	trigger_outputs()

# Called when the device is interacted with.
func _on_interacted():
	set_state(not enabled)
	if single_interaction:
		collision.disabled = true

# Triggers the outputs of all connected interactable devices.
func trigger_outputs():
	for interactable_device in interactable_devices:
		interactable_device._interact()

# Updates the visual state of the device based on its enabled state.
func update_visual_state():
	if sprite.material is ShaderMaterial:
		var shader_material: ShaderMaterial = sprite.material
		shader_material.set_shader_parameter("enabled", 1.0 if enabled else 0.0)