extends InteractableDevice
class_name GameEndTrigger


@export_enum("Bad", "Good") var EndType: int = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node is added to the scene.
func _ready():
	if sprite.material is ShaderMaterial:
		sprite.material = sprite.material.duplicate()

# Called when the device is interacted with.
func _on_interacted():
	collision.disabled = true
	print("You triggered the game end of type: ", "Bad" if EndType == 1 else "Good")

	# if EndType == 0:
	# 	audio.stream = GameManager.outro_audio
	# else:
	#global here
	#GameManager.TriggerGameEnd(EndType)
	Global.goto_scene("res://maps/outro_scene.tscn")
		