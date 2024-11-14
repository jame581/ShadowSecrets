extends MarginContainer

#@export var example_text: String = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Fusce consectetuer risus a nunc."

@onready var dialog_text: RichTextLabel = $VBoxContainer/HBoxContainer/Panel/MarginContainer/DialogText
@onready var dialog_image: TextureRect = $VBoxContainer/HBoxContainer/AIScreenTexture
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var write_timer: Timer = $WriteTimer
@onready var wait_timer: Timer = $WaitTimer

var ai_image_on: Texture = preload("res://assets/sprites/devices/pANIC/panic_face.png")
var ai_image_off: Texture = preload("res://assets/sprites/devices/pANIC/panic_blank.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogManager.connect("show_dialog", Callable(self, "show_dialog"))


func show_dialog(dialog_data: Dictionary) -> void:
	print("Dialog received: " + dialog_data["text"])
	dialog_image.texture = ai_image_off
	dialog_text.set_visible_characters(0)
	dialog_text.set_text(dialog_data["text"])
	wait_timer.wait_time = dialog_data["wait_time"] if dialog_data["wait_time"] > 0 else 2.0
	animation_player.play("show_dialog")


func hide_dialog() -> void:
	animation_player.play_backwards("show_dialog")
	dialog_image.texture = ai_image_off
	write_timer.stop()


func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "show_dialog":
		write_timer.start()
		dialog_image.texture = ai_image_on


func _on_write_timer_timeout() -> void:
	dialog_text.visible_characters += 1
	if dialog_text.visible_characters == dialog_text.get_total_character_count():
		write_timer.stop()
		wait_timer.start()

func _on_wait_timer_timeout() -> void:
	wait_timer.stop()
	hide_dialog()