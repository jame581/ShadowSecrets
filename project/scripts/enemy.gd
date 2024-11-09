extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_group("Enemy Properties")
@export var movement_speed: float = 100.0
@export var health: int = 100
@export var damage: int = 10

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var sprite: Sprite2D = get_node("Sprite")

var chase_player: bool = false
var player: Node = null

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var direction = 0
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif chase_player and player != null:
		direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)

	# Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var direction := Input.get_axis("ui_left", "ui_right")
	# if direction:
	# 	velocity.x = direction * SPEED
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, SPEED)
	select_animation(direction)
	flip_sprite_by_direction()
	move_and_slide()

func select_animation(direction) -> void:
	if direction:
		animation_player.play("walk")
	# elif chase_player:
	# 	animation_player.play("attack")
	else:
		animation_player.play("idle")

func flip_sprite_by_direction() -> void:
	if velocity.x != 0:
		if velocity.x < 0:
			sprite.scale.x = -1
			sprite.offset.x = 10
		else:
			sprite.scale.x = 1
			sprite.offset.x = 0

func _on_player_detect_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("Player entered!")
		chase_player = true
		player = body

func _on_player_detect_area_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		chase_player = false
		player = null
		print("Player exited!")