extends Node2D
class_name Spike

@export_group("Spike Properties")
@export var active: bool = false
@export var damage: int = 10
@export var timer_duration: float = 1.0
@export var impulse_strength: float = 500.0  # Strength of the impulse applied to the player

@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = timer_duration
	timer.start(timer_duration)

	if	active:
		enable()
	else:
		disable()

func toggle() -> void:
	active = not active
	enable() if active else disable()

func _on_timer_timeout() -> void:
	toggle();

func enable():
	collision_shape.disabled = false
	animation_player.play("enable")

func disable():
	collision_shape.disabled = true
	animation_player.play("disable")

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		body.deal_damage(damage)
		apply_impulse_to_player(body)

func apply_impulse_to_player(body):
	if body is CharacterBody2D:
		var direction = (body.global_position - global_position).normalized()
		body.apply_impulse(direction, impulse_strength)
#
#
#func _on_timer_timeout() -> void:
#	damage_player()
#
#func damage_player():
#	if player_ref:
#		player_ref.deal_damage(damage)
#		apply_impulse_to_player()
#
#func toggle():
#	active = !active
#	if active:
#		enable()
#	else:
#		disable()
#
#func _on_area_2d_body_entered(body):
#	if body.is_in_group("player"):
#		damage_player()
#


