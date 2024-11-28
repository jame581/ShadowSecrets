extends InteractableDevice
class_name Computer


@export var interactable_devices: Array[InteractableDevice] = []
@export var single_interaction: bool = false
@export_group("Dialog Setup")
@export var dialog_text: String = "Hello, world!"
@export var dialog_wait_time: float = 5.0

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var interaction: InteractionArea = $InteractionArea
@onready var collision: CollisionShape2D = $InteractionArea/CollisionShape2D

func _ready():
	if sprite.material is ShaderMaterial:
		sprite.material = sprite.material.duplicate()
	
	
# Triggers the outputs of all connected interactable devices.
func trigger_outputs():
	for interactable_device in interactable_devices:
		interactable_device._interact()

func _interact():
	enabled = !enabled

	if enabled:
		animation.play("enable")
		trigger_outputs()
		show_dialog()
	else:
		animation.play_backwards("enable")		

# In case of power generator this is called from animation player
func set_state(state: bool):
	enabled = state
	if enabled:
		Power.give_me_power()
		trigger_outputs()
		show_dialog()

func delayed_start():
	if not enabled:
		await get_tree().create_timer(1.0).timeout
		set_state(true)

func show_dialog() -> void:
	var dialog_data: Dictionary = {
		"text": dialog_text,
		"wait_time": dialog_wait_time,
		"hide_dialog_after": true
	}
	DialogManager.emit_signal("show_dialog", dialog_data)

func _on_interaction_area_interacted():
	_interact()
	if single_interaction:
		interaction.monitoring = false
		collision.disabled = true