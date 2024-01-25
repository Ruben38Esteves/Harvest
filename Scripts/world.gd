extends Node3D

#childs
@onready var hit_rect = $UI/ColorRect
@onready var zombie_spawn_points = $map/Spawns
@onready var navigation_region = $map/NavigationRegion3D
@onready var zombie_spawn_timer = $ZombieSpawnTimer
@onready var crossair = $UI/crossair
@onready var crossair2 = $UI/crossair2
@onready var time = $UI/Hud/timer/Time
@onready var chest_spawns = $map/Chest_spawns
@onready var word_clock = $WordClock

#loads
var zombie = load("res://Scenes/zombie.tscn")
var chest = load("res://Scenes/chest.tscn")
var instance

#variables
var time_seconds = 0
var time_minutes = 0
var time_hours = 0

#signals
signal add_ammo
signal add_money

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	crossair.position.x = (get_viewport().size.x / 2) - 5
	crossair.position.y = (get_viewport().size.y / 2) - 5
	crossair2.position.x = (get_viewport().size.x / 2) - 5
	crossair2.position.y = (get_viewport().size.y / 2) - 5
	for i in 8:
		var spawn_point = _get_random_child(chest_spawns).global_position
		instance = chest.instantiate() 
		instance.global_position = spawn_point
		instance.chest_opened.connect(_on_chest_opened)
		navigation_region.add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_player_hit():
	hit_rect.visible = true
	await get_tree().create_timer(0.3).timeout
	hit_rect.visible = false
	
func _get_random_child(parent_node):
	var child_node_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(child_node_id)


func _on_zombie_spawn_timer_timeout():
	if zombie_spawn_timer.wait_time > 1:
		zombie_spawn_timer.wait_time -= 0.05
	var spawn_point = _get_random_child(zombie_spawn_points).global_position
	instance = zombie.instantiate() 
	instance.global_position = spawn_point
	instance.zombie_hit.connect(_on_zombie_zombie_hit)
	instance.zombie_killed.connect(_on_zombie_zombie_killed)
	navigation_region.add_child(instance)

func _on_zombie_zombie_hit():
	crossair2.visible = true
	await get_tree().create_timer(0.1).timeout
	crossair2.visible = false

func _on_zombie_zombie_killed():
	var ammo_chance = randi() % 10
	if ammo_chance >= 0 and ammo_chance < 6:
		emit_signal("add_ammo", 2)
	elif ammo_chance >= 6 and ammo_chance < 8:
		emit_signal("add_ammo", 1)
		
func _on_chest_opened():
	print("abriu")
	
func calc_money():
	pass

func _on_word_clock_timeout():
	time_seconds += 1
	if time_seconds == 61:
		time_seconds = 0
		time_minutes += 1
	update_timer()
		
func update_timer():
	var value =  str(time_minutes) + ":" + str(time_seconds)
	time.text = value
