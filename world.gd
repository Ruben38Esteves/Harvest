extends Node3D

@onready var hit_rect = $UI/ColorRect
@onready var zombie_spawn_points = $map/Spawns
@onready var navigation_region = $map/NavigationRegion3D

var zombie = load("res://Scenes/zombie.tscn")
var instance

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


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
	navigation_region.add_child(instance)
