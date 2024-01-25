extends CSGBox3D

signal chest_used
@onready var timer = $"../Timer"
@onready var shader = $".".material.next_pass
@onready var shader1 = self.material.next_pass
@onready var chest = $".."
var targeted = false : set = set_targeted

func set_targeted(val):
	targeted = val
	if targeted:
		shader.set_shader_parameter("strength", 3.0)
	else:
		shader.set_shader_parameter("strength", 0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func used(money):
	return chest.open_chest(money)

func shader_value(boolean):
	if boolean:
		return 0.2
	else:
		return 0.0
