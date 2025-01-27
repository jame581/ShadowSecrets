extends MarginContainer

class_name DialogDisplay

signal message_displayed()
signal dialog_finished()

@export var write_timer_duration: float = 0.05
@export var portrait: Texture = preload("res://assets/sprites/intro/portrait-mc.png")
@export var press_enter_visible: bool = true

@onready var dialog_text: RichTextLabel = $VBoxContainer/HBoxContainer/PanelText/MarginContainer/DialogText
@onready var dialog_image: TextureRect = $VBoxContainer/HBoxContainer/PanelScreen/AIScreenTexture
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var write_timer: Timer = $WriteTimer
@onready var wait_timer: Timer = $WaitTimer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var press_to_continue: Label = $VBoxContainer/PressToContinueLabel

var ai_image_on: Texture = preload("res://assets/sprites/devices/pANIC/panic_face.png")
var ai_image_off: Texture = preload("res://assets/sprites/devices/pANIC/panic_blank.png")

var hide_dialog_after: bool = false
var dialog_writing: bool = false
var dialog_shown: bool = false

var dialog_playing: bool = false
var dialog_queue: Array = []

var wait_for_input: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogManager.connect("show_dialog", Callable(self, "show_dialog"))
	visible = false
	write_timer.wait_time = write_timer_duration
	press_to_continue.visible = press_enter_visible


func show_dialog(dialog_data: Dictionary) -> void:
	if dialog_playing:
		dialog_queue.append(dialog_data)
		return
	
	dialog_playing = true
	dialog_image.texture = null
	dialog_text.set_visible_characters(0)
	dialog_text.set_text(dialog_data["text"])
	wait_timer.wait_time = dialog_data["wait_time"] if dialog_data["wait_time"] > 0 else 2.0
	hide_dialog_after = dialog_data["hide_dialog_after"] if dialog_data.has("hide_dialog_after") else true
	portrait = dialog_data["portrait"] if dialog_data.has("portrait") else portrait

	animation_player.play("show_dialog")
	visible = true


func display_next_message(dialog_data: Dictionary) -> void:
	if visible:
		dialog_text.set_visible_characters(0)
		dialog_text.set_text(dialog_data["text"])
		wait_timer.wait_time = dialog_data["wait_time"] if dialog_data["wait_time"] > 0 else 2.0
		hide_dialog_after = dialog_data["hide_dialog_after"] if dialog_data.has("hide_dialog_after") else true
		portrait = dialog_data["portrait"] if dialog_data.has("portrait") else portrait

		write_timer.start()
		dialog_writing = true
		if !audio_player.is_playing():
			audio_player.play()
	else:
		show_dialog(dialog_data)


func hide_dialog() -> void:
	animation_player.play("hide_dialog")
	dialog_image.texture = null
	write_timer.stop()
	wait_timer.stop()
	audio_player.stop()
	dialog_shown = false
	dialog_playing = false
	dialog_finished.emit()


func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "show_dialog":
		write_timer.start()
		dialog_writing = true
		dialog_image.texture = portrait
		dialog_shown = true
		if !audio_player.is_playing():
			audio_player.play()
	elif anim_name == "hide_dialog":
		dialog_writing = false
		dialog_shown = false
		check_next_message()


func check_next_message() -> void:
	if dialog_queue.size() > 0:
		show_dialog(dialog_queue.pop_front())
	else:
		dialog_playing = false

func _on_write_timer_timeout() -> void:
	dialog_text.visible_characters += 1
	if dialog_text.visible_characters == dialog_text.get_total_character_count():
		write_timer.stop()
		dialog_writing = false
		audio_player.stop()
		if not wait_for_input:
			wait_timer.start()


func finish_writing() -> void:
	if not dialog_shown:
		return

	if dialog_writing:
		write_timer.stop()
		dialog_writing = false
		dialog_text.visible_characters = dialog_text.get_total_character_count()
		audio_player.stop()
		if not wait_for_input:
			wait_timer.start()
	elif !wait_timer.is_stopped():
		_on_wait_timer_timeout()


func _on_wait_timer_timeout() -> void:
	wait_timer.stop()
	audio_player.stop()
	message_displayed.emit()
	if hide_dialog_after:
		hide_dialog()
	
