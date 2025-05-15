extends Node3D

#childs

@onready var zombie_spawn_points = $map/Spawns
@onready var chest_spawns = $map/Chest_spawns
@onready var navigation_region = $map/NavigationRegion3D
@onready var zombie_spawn_timer = $ZombieSpawnTimer
#@onready var hit_rect = $UI/ColorRect
#@onready var crossair = $UI/crossair
#@onready var crossair2 = $UI/crossair2
#@onready var time = $UI/Hud/timer/Time
#@onready var kill_amount_display = $UI/Hud/timer/Kills/KillAmount
#@onready var info = $UI/Info
@onready var word_clock = $WordClock
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
	# set_corsair_location()
	spawn_player_weapons()
	spawn_chests(8)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
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

#func _on_player_player_hit():
	#hit_rect.visible = true
	#await get_tree().create_timer(0.3).timeout
	#hit_rect.visible = false
	
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
	global.player._on_zombie_zombie_hit()

func _on_zombie_zombie_killed():
	print("he died")
	global.player._on_zombie_zombie_killed()
		
func _on_chest_opened():
	player.recieve_ammo()
	#info.text = "You found ammo"
	#info.visible = true
	
func calc_money():
	pass
