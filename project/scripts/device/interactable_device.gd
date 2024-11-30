extends Node2D
class_name InteractableDevice

@export var enabled: bool = false:
	set(value):
		enabled = value
		_on_enabled_changed()

func _process(_delta):
	pass

func _interact():
	pass

func _on_enabled_changed():
	pass