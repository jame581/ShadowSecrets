extends Node2D

@export_group("Trap Properties")
@export var damage: int = 10
@export var timer_duration: float = 1.5

@onready var timer: Timer = $Timer

var player_ref : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = timer_duration


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	if player_ref:
		player_ref.deal_damage(damage)
	
	queue_free()

func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_ref = body
		timer.start()