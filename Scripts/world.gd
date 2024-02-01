extends Node3D

#childs
@onready var hit_rect = $UI/ColorRect
@onready var zombie_spawn_points = $map/Spawns
@onready var chest_spawns = $map/Chest_spawns
@onready var navigation_region = $map/NavigationRegion3D
@onready var zombie_spawn_timer = $ZombieSpawnTimer
@onready var crossair = $UI/crossair
@onready var crossair2 = $UI/crossair2
@onready var time = $UI/Hud/timer/Time
@onready var word_clock = $WordClock
@onready var kill_amount_display = $UI/Hud/timer/Kills/KillAmount
@onready var info = $UI/Info
@onready var player = $map/Player
@onready var player_primary = $map/Player/Head/Camera3D/Hands/Primary
@onready var player_secondary = $map/Player/Head/Camera3D/Hands/Secondary
@onready var player_meelee = $map/Player/Head/Camera3D/Hands/Meelee

#loads
var zombie = load("res://Scenes/zombie.tscn")
var chest = load("res://Scenes/Interactables/chest.tscn")
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
	set_corsair_location()
	spawn_player_weapons()
	spawn_chests(8)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_corsair_location():
	crossair.position.x = (get_viewport().size.x / 2) - 5
	crossair.position.y = (get_viewport().size.y / 2) - 5
	crossair2.position.x = (get_viewport().size.x / 2) - 5
	crossair2.position.y = (get_viewport().size.y / 2) - 5
	
func spawn_player_weapons():
	var primary_weapon = load(global.primary_weapon_path)
	var secondary_weapon = load(global.secondary_weapon_path)
	var meelee_weapon = load(global.meelee_weapon_path)
	instance = primary_weapon.instantiate()
	player.primary.add_child(instance)
	instance = secondary_weapon.instantiate()
	player.secondary.add_child(instance)
	instance = meelee_weapon.instantiate()
	player.meelee.add_child(instance)
	player.load_weapon_variables()

func _on_player_player_hit():
	hit_rect.visible = true
	await get_tree().create_timer(0.3).timeout
	hit_rect.visible = false
	
func _get_random_child(parent_node):
	var child_node_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(child_node_id)

func spawn_chests(amount):
	for i in amount:
		var spawn_point = _get_random_child(chest_spawns).global_position
		instance = chest.instantiate() 
		instance.global_position = spawn_point
		instance.chest_opened.connect(_on_chest_opened)
		navigation_region.add_child(instance)

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
	kill_amount += 1
	kill_amount_display.text = str(kill_amount)
		
func _on_chest_opened():
	player.recieve_ammo()
	Inventory.gun_damage += 1.0
	player.update_items()
	info.text = "You found ammo"
	info.visible = true
	
func calc_money():
	pass

func _on_word_clock_timeout():
	time_seconds += 1
	if time_seconds == 61:
		time_seconds = 0
		time_minutes += 1
	update_timer()
		
func update_timer():
	var value
	if time_seconds < 10:
		value =  str(time_minutes) + ":0" + str(time_seconds)
	else:
		value =  str(time_minutes) + ":" + str(time_seconds)
	time.text = value
