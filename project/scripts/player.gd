extends CharacterBody2D

@export_group("Player Movement")
@export var player_speed = 300
@export var jump_velocity = -400

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var healt_component = get_node("Components/HealthComponent")
@onready var god_mode_icon = $PlayerUI/GodModeIcon
@onready var death_timer = $DeathTimer

var jump_pressed : bool = false
var falling : bool = false

var explosion_ticks : int = 0
var explosion_impulse : Vector2 = Vector2.ZERO

var is_dead : bool = false

func _ready() -> void:
	healt_component.health_changed.connect(health_changed)
	GameManager.god_mode_changed.connect(_handle_god_mode_changed)
	GameManager.game_is_over.connect(_handle_game_over)
	god_mode_icon.visible = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		falling = true
	else:
		jump_pressed = false
		falling = false

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
	if is_dead:
		animation_player.play("death")
	elif jump_pressed:
		animation_player.play("jump")
	elif falling:
		animation_player.play("falling")
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
	if GameManager.is_god_mode or is_dead:
		return

	healt_component.update_health(damage)
	# Insanity.insanity_hit(Insanity.insanity_level.HIGH)

func apply_impulse(direction: Vector2, strength: float) -> void:
	explosion_impulse += direction.normalized() * strength
	explosion_ticks = 10

func process_explosion():
	explosion_ticks = explosion_ticks - 1
	velocity = explosion_impulse
	if explosion_ticks == 0:
		explosion_impulse = Vector2.ZERO

func health_changed(new_value: int) -> void:
	if new_value <= 0:
		print("Player died")
		is_dead = true
		death_timer.start()


func _handle_god_mode_changed(is_god: bool) -> void:
	god_mode_icon.visible = is_god


func _handle_game_over() -> void:
	is_dead = true
	velocity = Vector2.ZERO


func _on_death_timer_timeout() -> void:
	print("Player death timer timeout")
	GameManager.game_over()