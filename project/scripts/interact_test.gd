extends Node2D

@export var interaction_text : String = ""

@onready var interaction_area = $InteractionArea
@onready var sprite = $Sprite
@onready var speech_label: Label = $SpeechLabel
@onready var timer: Timer = $Timer

var index = 0;

const lines: Array = [
	"Hello, I am a test NPC.",
	"I am here to test the interaction system.",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interaction_text = interaction_text
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	timer.start()
	#sprite.flip_y = !sprite.flip_y


func _on_timer_timeout() -> void:
	if index >= lines.size():
		index = 0
		timer.stop()
		speech_label.text = ""
	else:	
		speech_label.text = lines[index]
		index += 1
