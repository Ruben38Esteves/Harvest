extends Node3D
@onready var path_3d: Path3D = $Path3D
@onready var area_3d: Area3D = $Area3D
@onready var timer: Timer = $Timer

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
	

func create_lightning_path(start: Vector3, end: Vector3, segments: int = 10, offset: float = 0.5):
	var curve = Curve3D.new()
	for i in range(segments + 1):
		var t = float(i) / segments
		var pos = start.lerp(end, t)
		if i != 0 and i != segments:
			pos += Vector3(
				randf_range(-offset, offset),
				randf_range(-offset, offset),
				randf_range(-offset, offset)
			)
		curve.add_point(pos)
	path_3d.curve = curve


func _on_timer_timeout() -> void:
	var next_target = get_closest_body()
	print(next_target)
	# no more targets
	if next_target == null:
		queue_free()
	next_target.hit(10)
	length -= 1
	if length > 0:
		spread(next_target)
	else:
		queue_free()
		
func spread(next_target):
	global_position = next_target.global_position
	enemies_hit[next_target.get_parent()] = true
	timer.start()
