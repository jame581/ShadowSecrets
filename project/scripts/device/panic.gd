extends InteractableDevice
class_name PANIC

#Paranoid Android Network, Inefficient and Clumsy

@export_group("Dialog Setup 1")
@export var dialog_text : String = "Hello, world!"
@export var dialog_wait_time : float = 5.0
@export var hide_after: bool = true
@export_enum("MC", "AI") var picture: int = 0

@export_group("Dialog Setup 2")
@export var dialog_text_2 : String = ""
@export var dialog_wait_time_2 : float = 0.0
@export var hide_after_2: bool = false
@export_enum("MC", "AI") var picture_2: int = 0

@export_group("Dialog Setup 3")
@export var dialog_text_3 : String = ""
@export var dialog_wait_time_3 : float = 0.0
@export var hide_after_3: bool = false
@export_enum("MC", "AI") var picture_3: int = 0


@export_group("Dialog Config")
@export var portrait_MC: Texture = preload("res://assets/sprites/intro/portrait-mc.png")
@export var portrait_AI: Texture = preload("res://assets/sprites/intro/portrait-AI.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# Create a timer
	# var timer = Timer.new()
	# timer.wait_time = 10.0
	# timer.one_shot = true
	# timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	# add_child(timer)
	# timer.start()

func _interact():
	enabled = not enabled

	if	enabled:
		$AnimationPlayer.play("enable")
		await get_tree().create_timer(2.0).timeout
		show_dialog()
	else:
		$AnimationPlayer.play("disable")

func _on_Timer_timeout():
	pass
	#$AnimationPlayer.play("enable")

func show_dialog() -> void:
	var dialog_data: Dictionary = {
		"text": dialog_text,
		"wait_time": dialog_wait_time,
		"portrait": portrait_AI if picture == 1 else portrait_MC,
		"hide_dialog_after": hide_after
	}
	var dialog_data_2: Dictionary = {
		"text": dialog_text_2,
		"wait_time": dialog_wait_time_2,
		"portrait": portrait_AI if picture_2 == 1 else portrait_MC,
		"hide_dialog_after": hide_after_2
	}
	var dialog_data_3: Dictionary = {
		"text": dialog_text_3,
		"wait_time": dialog_wait_time_3,
		"portrait": portrait_AI if picture_3 == 1 else portrait_MC,
		"hide_dialog_after": hide_after_3
	}
	
	DialogManager.emit_signal("show_dialog", dialog_data)
	if dialog_wait_time_2 > 0:
		DialogManager.emit_signal("show_dialog", dialog_data_2)
		print("Dialog 2")
	if dialog_wait_time_3 > 0:
		DialogManager.emit_signal("show_dialog", dialog_data_3)