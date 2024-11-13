extends CharacterBody2D

class_name Enemy

# export variables
@export_group("Enemy Properties")
@export var movement_speed: float = 100.0
@export var jump_speed: float = -600.0
@export var health: int = 100
@export var damage: int = 25
@export var attack_range: int = 50
@export var player_position_changed_threshold: float = 20.0

# onready variables
@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var sprite: Sprite2D = get_node("Sprite")
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var update_player_position_timer: Timer = $UpdatePlayerPositionTimer

# private variables
var chase_player: bool = false
var player: Node = null
var last_player_position: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO
var return_to_home: bool = false
var is_attacking_player: bool = false
var jump_now: bool = false


func _ready() -> void:
	start_position = global_position

	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 20.0
	navigation_agent.target_desired_distance = 10.0

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

	# update_player_position_timer.start()
	update_player_position_timer.timeout.connect(update_player_position)


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	navigation_agent.link_reached.connect(_on_link_reached)


func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


func _process(delta: float) -> void:
	if chase_player and player != null:
		if global_position.distance_to(player.global_position) < attack_range:
			attack_player()
		else:
			is_attacking_player = false


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		select_animation(velocity)
		flip_sprite_by_velocity()
		move_and_slide()
		return

	if jump_now:
		print("Jumping madafaka")
		velocity.y = jump_speed
		select_animation(velocity)
		flip_sprite_by_velocity()
		jump_now = false
		move_and_slide()
		return

	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		select_animation(velocity)
		flip_sprite_by_velocity()
		return

	if is_attacking_player:
		velocity = Vector2.ZERO
		select_animation(velocity)
		flip_sprite_by_velocity()
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	# print("current_agent_position: ", current_agent_position, "next_path_position: ", next_path_position, "velocity: ", velocity)
	
	select_animation(velocity)
	flip_sprite_by_velocity()
	move_and_slide()


func attack_player():
	is_attacking_player = true
	print("Attacking player")


func select_animation(direction) -> void:
	if is_attacking_player:
		animation_player.play("attack")
	elif direction.x:
		animation_player.play("walk")
	else:
		animation_player.play("idle")


func flip_sprite_by_velocity() -> void:
	if velocity.x != 0:
		if velocity.x < 0:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1


func _on_player_detect_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("Player entered!")
		chase_player = true
		player = body
		last_player_position = player.global_position
		set_movement_target(last_player_position)
		update_player_position_timer.start()


func _on_player_detect_area_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		chase_player = false
		last_player_position = player.global_position
		player = null
		# return_timer.start()
		update_player_position_timer.stop()
		print("Player exited!")


func _on_attack_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.call_deferred("deal_damage", damage)
		print("Player attacked!")


func _on_link_reached(details) -> void:
	print("Link reached details: ", details)
	
	var link_exit_position: Vector2 = details["link_exit_position"]
	print("Link exit position: ", link_exit_position)
	print("Global position: ", global_position)

	if global_position.y > link_exit_position.y:
		print("Jumping madafaka")
		jump_now = true


func update_player_position() -> void:
	if player != null:
		if player.global_position.distance_to(last_player_position) > player_position_changed_threshold:
			last_player_position = player.global_position
			set_movement_target(last_player_position)
			print("Updating player position: ", last_player_position)