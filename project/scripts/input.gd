extends InteractableDevice
class_name InputDevice

@export var enabledColor: Color = Color("#a8ca58")
@export var disabledColor: Color = Color("#cf573c")


@export var interactable_devices: Array[InteractableDevice] = []


@onready var sprite: Sprite2D = $Sprite2D

func _process(_delta):
	pass

func update_state():
	if sprite.material is ShaderMaterial:
		var shader_material = sprite.material
		var color = enabledColor if enabled else disabledColor
		
		shader_material.set_shader_parameter("tint_color", color)
		shader_material.set_shader_parameter("enabled", 1.0)

func _on_interacted():
	enabled = !enabled
	update_state()
	triggerOutputs()

func triggerOutputs():
	for interactable_device in interactable_devices:
		interactable_device._interact()
