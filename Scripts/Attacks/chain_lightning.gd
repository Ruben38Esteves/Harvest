extends Node3D
@onready var path_3d: Path3D = $Path3D
@onready var area_3d: Area3D = $Area3D
@onready var timer: Timer = $Timer
const LIGHTNING_STRIKE = preload("res://Scenes/Attacks/LightningStrike.tscn")
@onready var path_follow: PathFollow3D = $Path3D/PathFollow3D
@onready var particles: GPUParticles3D = $Path3D/PathFollow3D/GPUParticles3D
var tween = null

var length: int = 1
var enemies_hit = {}

func _ready() -> void:
	var tween = create_tween()

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
	

#func create_lightning_path(start: Vector3, end: Vector3, segments: int = 10, offset: float = 0.5):
	#var curve = Curve3D.new()
	#for i in range(segments + 1):
		#var t = float(i) / segments
		#var pos = start.lerp(end, t)
		#if i != 0 and i != segments:
			#pos += Vector3(
				#randf_range(-offset, offset),
				#randf_range(-offset, offset),
				#randf_range(-offset, offset)
			#)
		#curve.add_point(pos)
	#path_3d.curve = curve
#
#func emit_particles_along_path():
	#var tween = get_tree().create_tween()
	#path_follow.progress_ratio = 0.0
	#particles.emitting = true
	#
	#tween.tween_property(path_follow, "progress_ratio", 1.0, 0.5)
	#tween.tween_callback(Callable(self, "_on_particle_done"))
	#tween.play()
	#
#func _on_particle_done():
	#particles.emitting = false
	
	
func spawn_beam(target_location: Vector3):
	var instance = LIGHTNING_STRIKE.instantiate()
	instance.scale
	instance.rotate_y(global_position.angle_to(target_location))
	add_child(instance)
	
	#var from = global_position
	#var to = target_location
	#var direction = to - from
	#var length = direction.length()
	#var mid_point = from + direction * 0.5
#
	#var base_scale = instance.scale
	#instance.scale = Vector3(base_scale.x, base_scale.y, length)
#
	## Set global position first
	#instance.global_position = mid_point
	#instance.rotation_degrees.y = -90.0
#
	## Look at target from midpoint
	#instance.look_at(to, Vector3.UP)
#
	#get_parent().add_child(instance)



func _on_timer_timeout() -> void:
	var next_target = get_closest_body()
	print(next_target)
	# no more targets
	if next_target == null:
		queue_free()
		
	#create_lightning_path(global_position, next_target.global_position)
	#emit_particles_along_path()
	
	spawn_beam( next_target.global_position)
	
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
