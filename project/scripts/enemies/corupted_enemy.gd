extends Enemy


func _ready() -> void:
	super._ready()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)


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
		# return_timer.start()
		update_player_position_timer.stop()


func _on_attack_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.call_deferred("deal_damage", damage)
