class_name hitbox

extends Area3D

signal body_hit(delta)
var parent = null

@export var dmg_scaling: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	self.area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(dmg, hit_location = position):
	parent.hit(dmg * dmg_scaling, hit_location)
	
func melee_hit(dmg, hit_location = position):
	parent.hit(dmg, hit_location)
	return parent

func _on_area_entered(area):
	print(area)
