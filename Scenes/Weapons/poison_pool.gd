extends Node3D


@onready var timer = $timer
@onready var collision_shape = $Area3D/CollisionShape3D
@onready var area_3d = $Area3D
var damage = 35

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()


func _on_damage_timer_timeout():
	for i in area_3d.get_overlapping_bodies():
		if i.is_in_group("enemy"):
			i.attacked(damage)
