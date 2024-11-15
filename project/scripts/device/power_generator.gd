extends InteractableDevice
class_name PowerGenerator

@onready var animation: AnimationPlayer = $AnimationPlayer

var phase : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _interact():
	phase += 1
	if phase > 3:
		animation.play("active")
	else:
		animation.play("sequence"+str(phase))


