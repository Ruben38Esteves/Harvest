extends Node3D

var primary_picked_bool : bool
var secondary_picked_bool : bool
@onready var primaries = $map/primaries
@onready var secondaries = $map/secondaries

# Called when the node enters the scene tree for the first time.
func _ready():
	primary_picked_bool = false
	secondary_picked_bool = false
	print(primary_picked_bool)
	print(secondary_picked_bool)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func primary_picked():
	primary_picked_bool = true
	primaries.position.y = -10
	if secondary_picked_bool:
		get_tree().change_scene_to_file("res://Scenes/Levels/world.tscn")
		
func secondary_picked():
	secondary_picked_bool = true
	secondaries.position.y = -10
	if primary_picked_bool:
		get_tree().change_scene_to_file("res://Scenes/Levels/world.tscn")
		
	

func _on_play_shotgun_body_entered(body):
	if body.name == "Player":
		global.primary_weapon_path = "res://Scenes/Weapons/shotgun.tscn"
		primary_picked()

func _on_play_rifle_body_entered(body):
	if body.name == "Player":
		global.primary_weapon_path = "res://Scenes/Weapons/rifle.tscn"
		primary_picked()


func _on_play_gun_body_entered(body):
	if body.name == "Player":
		global.secondary_weapon_path = "res://Scenes/Weapons/hand_gun.tscn"
		print(primary_picked_bool)
		print(secondary_picked_bool)
		secondary_picked()


func _on_play_poison_body_entered(body):
	if body.name == "Player":
		global.secondary_weapon_path = "res://Scenes/Weapons/poison_flask.tscn"
		print(primary_picked_bool)
		print(secondary_picked_bool)
		secondary_picked()
