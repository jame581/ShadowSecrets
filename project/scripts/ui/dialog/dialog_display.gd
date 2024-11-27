extends MarginContainer

class_name DialogDisplay

signal message_displayed()

@export var write_timer_duration: float = 0.05
@export var portrait: Texture = preload("res://assets/sprites/intro/portrait-mc.png")

@onready var dialog_text: RichTextLabel = $VBoxContainer/HBoxContainer/PanelText/MarginContainer/DialogText
@onready var dialog_image: TextureRect = $VBoxContainer/HBoxContainer/PanelScreen/AIScreenTexture
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var write_timer: Timer = $WriteTimer
@onready var wait_timer: Timer = $WaitTimer

var ai_image_on: Texture = preload("res://assets/sprites/devices/pANIC/panic_face.png")
var ai_image_off: Texture = preload("res://assets/sprites/devices/pANIC/panic_blank.png")

var hide_dialog_after: bool = false
var dialog_writing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogManager.connect("show_dialog", Callable(self, "show_dialog"))
	visible = false
	write_timer.wait_time = write_timer_duration


func show_dialog(dialog_data: Dictionary) -> void:
	print("Dialog received: " + dialog_data["text"])
	dialog_image.texture = ai_image_off
	dialog_text.set_visible_characters(0)
	dialog_text.set_text(dialog_data["text"])
	wait_timer.wait_time = dialog_data["wait_time"] if dialog_data["wait_time"] > 0 else 2.0
	hide_dialog_after = dialog_data["hide_dialog_after"] if dialog_data.has("hide_dialog_after") else true
	animation_player.play("show_dialog")
	visible = true


func display_next_message(dialog_data: Dictionary) -> void:
	if visible:
		dialog_text.set_visible_characters(0)
		dialog_text.set_text(dialog_data["text"])
		wait_timer.wait_time = dialog_data["wait_time"] if dialog_data["wait_time"] > 0 else 2.0
		hide_dialog_after = dialog_data["hide_dialog_after"] if dialog_data.has("hide_dialog_after") else true
		write_timer.start()
		dialog_writing = true
	else:
		show_dialog(dialog_data)


func hide_dialog() -> void:
	animation_player.play_backwards("show_dialog")
	dialog_image.texture = ai_image_off
	write_timer.stop()


func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "show_dialog":
		write_timer.start()
		dialog_writing = true
		dialog_image.texture = portrait


func _on_write_timer_timeout() -> void:
	dialog_text.visible_characters += 1
	if dialog_text.visible_characters == dialog_text.get_total_character_count():
		write_timer.stop()
		dialog_writing = false
		print("Dialog Display - Message displayed")
		wait_timer.start()


func finish_writing() -> void:
	print("Dialog Display - Finish writing")
	print("Dialog Display - write_timer.is_stopped(): ", write_timer.is_stopped())
	if dialog_writing:
		print("Dialog Display - Stopping write timer")
		write_timer.stop()
		dialog_writing = false
		dialog_text.visible_characters = dialog_text.get_total_character_count()
		wait_timer.start()
	elif !wait_timer.is_stopped():
		print("Dialog Display - Stopping wait timer")
		_on_wait_timer_timeout()


func _on_wait_timer_timeout() -> void:
	wait_timer.stop()
	message_displayed.emit()
	
	if hide_dialog_after:
		hide_dialog()
	
