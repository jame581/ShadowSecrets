extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const OFFSET_FROM_POSITION = 10

@export_group("Enemy Properties")
@export var movement_speed: float = 100.0
@export var health: int = 100
@export var damage: int = 10


@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var sprite: Sprite2D = get_node("Sprite")
@onready var return_timer: Timer = get_node("ReturnToStartPositionTimer")

var chase_player: bool = false
var player: Node = null
var last_player_position: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO
var return_to_home : bool = false

func _ready() -> void:
	start_position = global_position


func _physics_process(delta: float) -> void:
	# Add the gravity.
	var direction = 0
	
	# Move the enemy.
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif chase_player and player != null: # Chase the player.
		direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * movement_speed
	elif last_player_position != Vector2.ZERO: # Move towards the last player position.
		direction = (last_player_position - global_position).normalized()
		velocity.x = direction.x * movement_speed
		if global_position.distance_to(last_player_position) < 5:
			last_player_position = Vector2.ZERO
			return_timer.start()
	elif return_to_home: # Return to the start position.
		direction = (start_position - global_position).normalized()
		velocity.x = direction.x * movement_speed
		if global_position.distance_to(start_position) < OFFSET_FROM_POSITION:
			return_to_home = false
	else: 
		velocity.x = move_toward(velocity.x, 0, movement_speed)

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

func _on_return_to_start_position_timer_timeout() -> void:
	if global_position.distance_to(start_position) > OFFSET_FROM_POSITION:
		return_to_home = true
		pass

func _on_player_detect_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("Player entered!")
		chase_player = true
		player = body

func _on_player_detect_area_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		chase_player = false
		last_player_position = player.global_position
		player = null		
		print("Player exited!")