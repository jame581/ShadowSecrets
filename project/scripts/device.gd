#@tool
extends Node2D

@export var enabled: bool = false
@onready var sprite: Sprite2D = $Sprite2D

func _process(_delta):
	if Engine.is_editor_hint():
		_debug_draw_state()

func _debug_draw_state():
	if sprite.material is ShaderMaterial:
		var shader_material = sprite.material
		var enabled_value = 1.0 if enabled else 0.0
		shader_material.set_shader_parameter("enabled", enabled_value)
