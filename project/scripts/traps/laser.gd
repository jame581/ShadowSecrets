extends InteractableDevice
class_name Laser

@export_group("Laser Properties")
@export var active: bool = false
@export var impulse_strength: float = 500.0  # Strength of the impulse applied to the player
@export var damage: Insanity.insanity_level = Insanity.insanity_level.MEDIUM

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if	active:
		enable()
	else:
		disable()

func _interact():
	toggle()

func toggle():
	active = !active
	if active:
		enable()
	else:
		disable()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		damage_player(body)

func enable():
	animation_player.play("enable")

func disable():
	animation_player.play("disable")

func apply_impulse_to_player(body: CharacterBody2D) -> void:
	if body is CharacterBody2D:
		var direction = (body.global_position - global_position).normalized()
		body.apply_impulse(direction, impulse_strength)

func damage_player(body: CharacterBody2D) -> void:
	body.call_deferred("deal_damage", damage)
	apply_impulse_to_player(body)