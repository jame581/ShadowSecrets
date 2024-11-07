@tool
extends Node2D
class_name Device

@export var enabled: bool = false
@onready var sprite: Sprite2D = $Sprite2D

func _process(_delta):
	if Engine.is_editor_hint():
		update_state()

func update_state():
	pass
#	if sprite.material is ShaderMaterial:
#		var shader_material = sprite.material
#		var enabled_value = 1.0 if enabled else 0.0
#		shader_material.set_shader_parameter("enabled", enabled_value)

