@tool
extends Device
class_name InputDevice

@export var enabledColor: Color = Color(0, 1, 0, 1)
@export var disabledColor: Color = Color(1, 0, 0, 1)


@export var output_devices: Array[OutputDevice] = []

func _process(_delta):
	pass
	if Engine.is_editor_hint():
		update_state()

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
	for output_device in output_devices:
		output_device._on_interacted()
