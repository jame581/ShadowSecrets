extends InteractableDevice
class_name ForceField

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

# Override
func _interact():
	toggle()

func toggle():
	active = !active
	if active:
		enable()
	else:
		disable()

func enable():
	sprite.play("enable")

func disable():
	sprite.play("disable")
