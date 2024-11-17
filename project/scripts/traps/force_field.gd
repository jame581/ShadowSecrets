extends InteractableDevice
class_name ForceField

@onready var collision: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node is added to the scene.
func _ready() -> void:
	if enabled:
		enable()
	else:
		disable()

# Called when the player interacts with the force field.
func _interact():
	toggle_state()

# Toggles the enabled state of the force field.
func toggle_state():
	enabled = !enabled
	if enabled:
		enable()
	else:
		disable()

# enables the force field.
func enable():
	collision.disabled = false
	sprite.play("enable")

# disables the force field.
func disable():
	collision.disabled = true
	sprite.play("disable")
