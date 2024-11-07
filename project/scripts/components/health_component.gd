extends Node

# Exported variables
@export_group("Health Component Properties")
@export var max_health : int = 100
@export var health_bar : ProgressBar

# Member variables
var current_health : int = 100

# Signals
signal health_changed(new_value)

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health
	if health_bar != null:
		health_bar.max_value = max_health
		health_bar.value = current_health


func update_health(health):
	current_health -= health;
	
	if current_health < 0:
		current_health = 0
	
	health_changed.emit(current_health)
	
	if health_bar != null:
		health_bar.value = current_health
