extends Node3D
@onready var path_3d: Path3D = $Path3D
@onready var area_3d: Area3D = $Area3D
@onready var timer: Timer = $Timer
@onready var projectile: Node3D = $Projectile

var length: int = 1
var enemies_hit = {}

func _ready() -> void:
	pass

func get_closest_body():
	var areas = area_3d.get_overlapping_areas()
	print(areas)
	var min_dist_area: Area3D = null
	var min_dist: float = 999999.0
	for area in areas:
		if not area.is_in_group("enemy"):
			continue
		if enemies_hit.has(area.get_parent()):
			continue
		var current_dist = global_position.distance_to(area.global_position)
		if current_dist < min_dist:
			min_dist = current_dist
			min_dist_area = area
	return min_dist_area



func _on_timer_timeout() -> void:
	var next_target = get_closest_body()
	print(next_target)
	# no more targets
	if not next_target or next_target == null:
		queue_free()
		return
	
	next_target.hit(10)
	length -= 1
	if length > 0:
		spread(next_target)
	else:
		queue_free()
		return
		
func spread(next_target):
	var tween = create_tween()
	tween.tween_property(self, "global_position", next_target.get_parent().global_position, 0.1)
	projectile.look_at(next_target.get_parent().global_position)
	#global_position = next_target.global_position
	enemies_hit[next_target.get_parent()] = true
	timer.start()
