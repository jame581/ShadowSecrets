@tool
extends Node2D
class_name InsanityJump

@export_enum("Goat", "Meow", "Claw") var insanity_type: int = 0:
	set(value):
		insanity_type = value
		update_insanity()

@export var debug_visible: bool = true:
	set(value):
		debug_visible = value
		if $DebugSprite:
			$DebugSprite.visible = debug_visible

@export var visibility_magic_number: float = 0.2

@export_category("DONT TOUCH THIS")
@export var textures: Array[Texture] = [null, null, null]
@export var sounds: Array[AudioStream] = [null, null, null]

@onready var animaton_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $InsanitySprite

func _ready():
	if sprite.material is ShaderMaterial:
		sprite.material = sprite.material.duplicate()
		sprite.material.set_shader_parameter("max_distance", visibility_magic_number)

	$DebugSprite.visible = false
	update_insanity()

# Setter function for insanity_type
func set_insanity_type(value: int) -> void:
	insanity_type = value
	update_insanity()

# Function to update the sprite texture based on the selected index
func update_insanity() -> void:
	var selected_index = clamp(insanity_type, 0, textures.size() - 1)
	$InsanitySprite.texture = textures[selected_index]
	$DebugSprite.texture = textures[selected_index]
	$AudioStreamPlayer2D.stream = sounds[selected_index]

func _on_area_2d_body_entered(body:Node2D):
	if body.is_in_group("player"):
		$AnimationPlayer.play("jump")
		$Area2D.monitoring = true
		Insanity.insanity_hit(Insanity.insanity_level.HIGH)
		Insanity.insanity_hit(Insanity.insanity_level.HIGH)
		Insanity.insanity_hit(Insanity.insanity_level.HIGH)
		Insanity.insanity_hit(Insanity.insanity_level.HIGH)
		await get_tree().create_timer(1.0).timeout
		queue_free()
