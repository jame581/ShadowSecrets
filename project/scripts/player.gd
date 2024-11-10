extends CharacterBody2D

@export_group("Player Movement")
@export var player_speed = 300
@export var jump_velocity = -400

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var healt_component = get_node("Components/HealthComponent")

var jump_pressed : bool = false

var explosion_ticks : int = 0
var explosion_impulse : Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_pressed = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		jump_pressed = true

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if explosion_ticks >= 0:
		process_explosion()
	else:
		if direction:
			velocity.x = direction * player_speed
		else:
			velocity.x = move_toward(velocity.x, 0, player_speed)

	select_animation(direction)
	flip_sprite_by_direction()
	move_and_slide()

func select_animation(direction) -> void:
	if jump_pressed:
		animation_player.play("jump")
	elif direction:
		animation_player.play("run")
	else:
		animation_player.play("idle")

func flip_sprite_by_direction() -> void:
	if velocity.x != 0:
		if velocity.x < 0:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1

func deal_damage(damage: int) -> void:
	healt_component.update_health(damage)

func apply_impulse(direction: Vector2, strength: float) -> void:
	explosion_impulse += direction.normalized() * strength
	explosion_ticks = 10

func process_explosion():
	explosion_ticks = explosion_ticks - 1
	velocity = explosion_impulse
	if explosion_ticks == 0:
		explosion_impulse = Vector2.ZERO
