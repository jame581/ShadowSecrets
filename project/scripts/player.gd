extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

#func _on_ready() -> void:
	#animation_player.play("idle")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animation_player.play("jump")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		animation_player.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			animation_player.play("idle")
	
	flip_sprite_by_direction()
	move_and_slide()


func flip_sprite_by_direction():
	if velocity.x != 0:
		if velocity.x < 0:
			sprite.scale.x = -1
			sprite.offset.x = 10
		else:
			sprite.scale.x = 1
			sprite.offset.x = 0
