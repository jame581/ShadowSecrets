extends Node2D

# The offset of the label from the interaction area.
@export var label_y_position_offset = 100

# Onready variables to get the player and the label.
@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

# The base text of the interaction label.
const base_text : String = "[E] to "

var active_areas : Array[InteractionArea] = []
var can_interact : bool = true

func register_area(area: InteractionArea) -> void:
	active_areas.push_back(area)

func unregister_area(area: InteractionArea) -> void:
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _process(delta: float) -> void:
	if not can_interact or active_areas.size() <= 0:
		label.hide()
		return

	active_areas.sort_custom(_sort_by_distance_to_player)
	_set_label(active_areas[0])
	# for area in active_areas:
	# 	if area.is_inside(player.get_global_position()):
	# 		label.text = base_text + area.interaction_text
	# 		if Input.is_action_just_pressed("interact"):
	# 			area.interact()
	# 			break

func _sort_by_distance_to_player(a: InteractionArea, b: InteractionArea) -> int:
	var a_distance = player.get_global_position().distance_to(a.get_global_position())
	var b_distance = player.get_global_position().distance_to(b.get_global_position())
	return a_distance < b_distance

func _set_label(active_area) -> void:
	label.text = base_text + active_area.interaction_text
	label.global_position = active_area.global_position
	label.global_position.y -= label_y_position_offset
	label.global_position.x -= label.size.x / 2
	label.show()

func _input(event: InputEvent) -> void:
	if active_areas.size() <= 0:
		return
	
	if event.is_action_pressed("interact"):
		can_interact = false
		label.hide()
		
		await active_areas[0].interact.call()

		can_interact = true
