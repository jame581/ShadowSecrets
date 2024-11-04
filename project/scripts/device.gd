#@tool
extends Node2D

@export var enabled: bool = false
@onready var sprite: Sprite2D = $Sprite2D
@onready var interaction_area = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _process(_delta):
	if Engine.is_editor_hint():
		update_state()

func update_state():
	if sprite.material is ShaderMaterial:
		var shader_material = sprite.material
		var enabled_value = 1.0 if enabled else 0.0
		shader_material.set_shader_parameter("enabled", enabled_value)

func _on_interact() -> void:
	if sprite.material is ShaderMaterial:
		var shader_material = sprite.material
		var enabled_value = shader_material.get_shader_parameter("enabled")
		shader_material.set_shader_parameter("enabled", !enabled_value)
