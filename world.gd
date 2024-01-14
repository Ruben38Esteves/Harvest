extends Node3D

@onready var hit_rect = $UI/ColorRect
@onready var zombie_spawn_points = $map/Spawns
@onready var navigation_region = $map/NavigationRegion3D

@onready var crossair = $UI/crossair
@onready var crossair2 = $UI/crossair2

var zombie = load("res://Scenes/zombie.tscn")
var instance

signal add_ammo

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	crossair.position.x = (get_viewport().size.x / 2) - 5
	crossair.position.y = (get_viewport().size.y / 2) - 5
	crossair2.position.x = (get_viewport().size.x / 2) - 5
	crossair2.position.y = (get_viewport().size.y / 2) - 5


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
	print(ammo_chance)
	if ammo_chance >= 0 and ammo_chance < 6:
		emit_signal("add_ammo", 2)
	elif ammo_chance >= 6 and ammo_chance < 8:
		emit_signal("add_ammo", 1)
