class_name hitbox

extends Area3D

signal body_hit(delta)

@export var dmg_scaling: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(dmg, hit_location = position):
	get_parent().hit(dmg * dmg_scaling, hit_location)
	
