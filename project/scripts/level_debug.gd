@tool
class_name MyTool
extends Node2D

@export var pulse_color: Color = Color(1,0,0,1)

func _process(delta):
	if $TileMapLayer.material is ShaderMaterial:
		var shader_material = $TileMapLayer.material
		shader_material.set_shader_parameter("tint_color", pulse_color)  # Apply the exported color setting
		shader_material.set_shader_parameter("pulse_speed", 2.0)  # Adjust the speed of the pulse
