@tool
extends InsanityJump
class_name InsanitySlide


@export_enum("Left", "Right", "Both") var Detection: int = 0

@onready var animation_slide_player: AnimationPlayer = $AnimationPlayer


func _ready():
	super._ready()

func _on_right_body_entered(body:Node2D):
	if body.is_in_group("player") && ( Detection == 1 || Detection == 2):
		animation_slide_player.play("to_right")

func _on_left_body_entered(body:Node2D):
	if body.is_in_group("player") && ( Detection == 0 || Detection == 2):
		animation_slide_player.play("to_left")