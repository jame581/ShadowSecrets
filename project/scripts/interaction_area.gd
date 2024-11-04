extends Area2D
class_name InteractionArea

@export var interaction_text: String = "Press 'E' to interact"

var interact: Callable = func():
	pass

func _ready() -> void:
	# set_process_input(true)
	pass

func _on_body_entered(body: Node) -> void:
	InteractionManager.register_area(self)

func _on_body_exited(body: Node) -> void:
	InteractionManager.unregister_area(self)
