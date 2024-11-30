extends Enemy


@onready var death_timer: Timer = $DeathTimer
@onready var explosion_particles: CPUParticles2D = $ExplosionParticles

var exploding: bool = false

func _ready() -> void:
	super._ready()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func select_animation(direction) -> void:
	if exploding:
		return
	
	if is_attacking_player:
		animation_player.play("attack")
	elif direction.x:
		animation_player.play("walk")
		audio_component.play_with_random_pitch(movement_audio, 0.8, 1.2)
	else:
		animation_player.play("idle")
		audio_component.stop_audio()

func _on_player_detect_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
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
		update_player_position_timer.stop()


func _on_attack_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.call_deferred("deal_damage", damage)
		explosion_particles.emitting = true
		exploding = true
		animation_player.play("explosion")
		audio_component.play_with_random_pitch(explosion_audio, 0.8, 1.2)
		death_timer.start()

func _on_death_timer_timeout() -> void:
	queue_free()