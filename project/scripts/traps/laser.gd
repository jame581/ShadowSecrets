extends Node2D
class_name Laser

@export_group("Laser Properties")
@export var active: bool = false
@export var damage: int = 10
@export var timer_duration: float = 1.0
@export var impulse_strength: float = 500.0  # Strength of the impulse applied to the player

@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var player_ref : CharacterBody2D

func _ready() -> void:
	if	active:
		enable()
	else:
		disable()

func _on_timer_timeout() -> void:
	damage_player()

func damage_player():
	if player_ref:
		player_ref.deal_damage(damage)
		apply_impulse_to_player()


func toggle():
	active = !active
	if active:
		enable()
	else:
		disable()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body
		damage_player()

func _on_area_2d_body_exited(body):
	player_ref = null

func enable():
	#collision_shape.disabled = false
	sprite.play("enable")

func disable():
	#collision_shape.disabled = true
	sprite.play("disable")

func apply_impulse_to_player():
	if player_ref:
		var direction = (player_ref.global_position - global_position).normalized()
		player_ref.apply_impulse(direction, impulse_strength)
