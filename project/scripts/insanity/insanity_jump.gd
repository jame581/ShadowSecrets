@tool
extends Node2D
class_name InsanityJump

@export_enum("Goat", "Meow", "Claw") var insanity_type: int = 0:
	set(value):
		insanity_type = value
		update_insanity()

@export var damage: Insanity.insanity_level = Insanity.insanity_level.LOW

@export var debug_visible: bool = true:
	set(value):
		print("Debug visible: ", value)
		debug_visible = value
		if $DebugShape:
			$DebugShape.visible = debug_visible

@export var visibility_magic_number: float = 0.2

@export_category("DONT TOUCH THIS")
@export var textures: Array[Texture] = [null, null, null]
@export var sounds: Array[AudioStream] = [null, null, null]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $InsanitySprite
@onready var area: Area2D = $Area2D

func _ready():
	if sprite.material is ShaderMaterial:
		sprite.material = sprite.material.duplicate()
		sprite.material.set_shader_parameter("max_distance", visibility_magic_number)

	# Editor-only code
	if !Engine.is_editor_hint():
		$DebugShape.visible = false
		$DebugName.visible = false
		update_insanity()	

# Function to update the sprite texture based on the selected index
func update_insanity() -> void:
	var selected_index = clamp(insanity_type, 0, textures.size() - 1)
	$InsanitySprite.texture = textures[selected_index]
	$DebugShape.texture = textures[selected_index]
	$AudioStreamPlayer2D.stream = sounds[selected_index]

func _on_area_2d_body_entered(body:Node2D):
	if body.is_in_group("player"):
		animation_player.play("jump")
		damage_player(body)
		area.monitoring = true
		await get_tree().create_timer(1.0).timeout
		queue_free()

func damage_player(body: CharacterBody2D) -> void:
	body.call_deferred("deal_damage", damage)
