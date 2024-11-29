extends Area2D

@export var dialog_text : String = "Hello, world!"
@export var dialog_wait_time : float = 5.0
@export var area_active: bool = true
@export var portrait: Texture = preload("res://assets/sprites/intro/portrait-mc.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if area_active and body.is_in_group("player"):
		print("Player entered the dialog area")		
		area_active = false		
		var dialog_data: Dictionary = {
			"text": dialog_text,
			"wait_time": dialog_wait_time,
			"hide_dialog_after": true,
			"portrait": portrait
		}
		DialogManager.emit_signal("show_dialog", dialog_data)