extends Node2D

@export_group("Trap Properties")
@export var damage: Insanity.insanity_level = Insanity.insanity_level.MEDIUM
@export_range(1, 10) var timer_duration: float = 1.5


@onready var timer: Timer = $Timer
@onready var explosion_timer: Timer = $ExplosionTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player_ref : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = timer_duration


func _on_timer_timeout() -> void:
	animation_player.play("trap_explosion")
	explosion_timer.start()
	if player_ref:
		player_ref.deal_damage(damage)


func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_ref = body
		animation_player.play("trap_activate")
		timer.start()


func _on_explosion_timer_timeout() -> void:
	queue_free()
