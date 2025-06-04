class_name hitbox

extends Area3D

signal body_hit(delta)
var parent = null

@export var dmg_scaling: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	#self.area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(dmg, hit_location = position, status = "none"):
	parent.hit(calculate_damage(dmg), hit_location, status)
	
func melee_hit(dmg, hit_location = position, status = "none"):
	parent.hit(dmg, hit_location, status)
	return parent
	
func calculate_damage(dmg) -> float:
	var broccolis = global.inventory.items["broccoli"]
	var final_dmg = dmg * (1.0 + (0.1 * broccolis)) * dmg_scaling
	return final_dmg

#func _on_area_entered(area):
	#print(area)
