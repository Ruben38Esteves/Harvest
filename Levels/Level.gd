class_name level
extends Node3D

#childs
@export var chest_spawn_points: Node3D = null
@export var nav_region: NavigationRegion3D = null
@export var zombie_spawn_timer: Timer = null

#loads
var zombie = load("res://Enemies/Zombie/zombie.tscn")
var chest = load("res://Terrain/Interactables/Chest/chest.tscn")
var instance

#variables
var time_seconds = 0
var time_minutes = 0
var time_hours = 0
var kill_amount = 0

#signals
signal add_ammo
signal add_money

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	spawn_player_weapons()
	zombie_spawn_timer.timeout.connect(_on_zombie_spawn_timer_timeout)
	#spawn_chests(8)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func spawn_player_weapons():
	var primary_weapon = load(global.primary_weapon_path)
	var secondary_weapon = load(global.secondary_weapon_path)
	var meelee_weapon = load(global.meelee_weapon_path)
	instance = primary_weapon.instantiate()
	global.player.primary.add_child(instance)
	instance = secondary_weapon.instantiate()
	global.player.secondary.add_child(instance)
	instance = meelee_weapon.instantiate()
	global.player.meelee.add_child(instance)
	global.player.load_weapon_variables()

#func _on_player_player_hit():
	#hit_rect.visible = true
	#await get_tree().create_timer(0.3).timeout
	#hit_rect.visible = false
	
func _get_random_child(parent_node):
	var child_node_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(child_node_id)

#func spawn_chests(amount):
	#for i in amount:
		#var spawn_point = _get_random_child(chest_spawns).global_position
		#instance = chest.instantiate() 
		#instance.global_position = spawn_point
		#instance.cost = 10
		##instance.chest_opened.connect(_on_chest_opened)
		#navigation_region.add_child(instance)

func _on_zombie_spawn_timer_timeout():
	if zombie_spawn_timer.wait_time > 1:
		zombie_spawn_timer.wait_time -= 0.05
		
	var random_angle = randf_range(0, TAU)
	var random_offset = Vector3(cos(random_angle), 0, sin(random_angle)) * randf_range(10, 20)
	var potential_target = global.player.global_position + random_offset
	var nav_map = get_world_3d().get_navigation_map()
	var spawn_point = NavigationServer3D.map_get_closest_point(nav_map, potential_target)
		
	#var spawn_point = NavigationServer3D.map_get_random_point(nav_region, 1, false)
	instance = zombie.instantiate() 
	instance.global_position = spawn_point
	#instance.zombie_hit.connect(_on_zombie_zombie_hit)
	#instance.zombie_killed.connect(_on_zombie_zombie_killed)
	instance.set_stats(1)
	nav_region.add_child(instance)

func _on_zombie_zombie_hit():
	global.player._on_zombie_zombie_hit()

func _on_zombie_zombie_killed():
	global.player._on_zombie_zombie_killed()
		
func _on_chest_opened():
	global.player.recieve_ammo()
	
func calc_money():
	pass
