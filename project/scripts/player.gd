extends CharacterBody2D

@export_group("Player/Movement")
@export var player_speed = 300
@export var jump_velocity = -400

@export_group("Player/Audio Setup")
@export_subgroup("Death Sounds")
@export var death_sound: AudioStream = preload("res://assets/audio/player/stellarsecrets_sfx_player_death.wav")
@export var near_death_sound: AudioStream = preload("res://assets/audio/player/stellarsecrets_sfx_player_near_death.wav")
@export_subgroup("Foot steps Sounds")
@export var footsteps_sound: AudioStream = preload("res://assets/audio/player/stellarsecrets_sfx_player_footsteps.wav")
@export_subgroup("Hurt Sounds")
@export var hurt_sounds: Array[AudioStream] = [
	preload("res://assets/audio/player/stellarsecrets_sfx_player_hurt1.mp3"),
	preload("res://assets/audio/player/stellarsecrets_sfx_player_hurt2.mp3"),
	preload("res://assets/audio/player/stellarsecrets_sfx_player_hurt3.mp3")
]
@export_subgroup("Jump Sounds")
@export var landing_sound: AudioStream = preload("res://assets/audio/player/stellarsecrets_sfx_player_jump_landing.wav")
@export var jump_sounds: Array[AudioStream] = [
	preload("res://assets/audio/player/stellarsecrets_sfx_player_jump1.mp3"),
	preload("res://assets/audio/player/stellarsecrets_sfx_player_jump2.mp3"),
	preload("res://assets/audio/player/stellarsecrets_sfx_player_jump3.mp3"),
	preload("res://assets/audio/player/stellarsecrets_sfx_player_jump4.mp3")
]

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var hit = $HitPlayer

@onready var healt_component = get_node("Components/HealthComponent")
@onready var god_mode_icon = $PlayerUI/GodModeIcon
@onready var death_timer = $DeathTimer
@onready var audio_component = get_node("CharacterAudioComponent")
@onready var reset_hit_timer = $ResetHitTimer

var jump_pressed : bool = false
var falling : bool = false

var explosion_ticks : int = 0
var explosion_impulse : Vector2 = Vector2.ZERO

var is_dead : bool = false
var got_hit : bool = false


func _ready() -> void:
	healt_component.health_changed.connect(health_changed)
	Insanity.insanity_changed.connect(_handle_insanity_changed)
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
		audio_component.play_random_audio(jump_sounds)
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if explosion_ticks >= 0:
		process_explosion()
	else:
		if direction:
			velocity.x = direction * player_speed
			# audio_component.play_audio(footsteps_sound)
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
		audio_component.play_with_random_pitch(footsteps_sound, 0.9, 1.1)
	else:
		animation_player.play("idle")
		if audio_component.is_playing() and not got_hit:
			audio_component.stop_audio()

func flip_sprite_by_direction() -> void:
	if velocity.x != 0:
		if velocity.x < 0:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1

func deal_damage(damage: Insanity.insanity_level) -> void:
	if GameManager.is_god_mode or is_dead:
		return
	
	print("Player received damage: ", damage)
	got_hit = true
	audio_component.play_random_audio(hurt_sounds)
	reset_hit_timer.start()
	hit.play("hit_flash")
	Insanity.insanity_hit(damage)

func apply_impulse(direction: Vector2, strength: float) -> void:
	if is_dead:
		return

	explosion_impulse += direction.normalized() * strength
	explosion_ticks = 10

func process_explosion():
	explosion_ticks = explosion_ticks - 1
	velocity = explosion_impulse
	if explosion_ticks == 0:
		explosion_impulse = Vector2.ZERO

func health_changed(new_value: int) -> void:
	#we use sanity\insanity instead of health
	pass

func _handle_insanity_changed(new_insanity: float) -> void:
	if new_insanity >= 1.0:
		print("Player died")
		is_dead = true
		audio_component.play_audio(death_sound)
		death_timer.start()


func _handle_god_mode_changed(is_god: bool) -> void:
	god_mode_icon.visible = is_god


func _handle_game_over() -> void:
	is_dead = true
	velocity = Vector2.ZERO


func _on_death_timer_timeout() -> void:
	print("Player death timer timeout")
	GameManager.game_over()

func _on_reset_hit_timer_timeout() -> void:
	got_hit = false
	reset_hit_timer.stop()