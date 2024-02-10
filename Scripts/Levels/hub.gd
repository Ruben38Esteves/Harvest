extends Node3D

@onready var crossair = $UI/crossair
@onready var crossair2 = $UI/crossair2
var primary_picked_bool = false
var secondary_picked_bool = false
@onready var primaries = $map/primaries
@onready var secondaries = $map/secondaries

# Called when the node enters the scene tree for the first time.
func _ready():
	set_corsair_location()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_corsair_location():
	crossair.position.x = (get_viewport().size.x / 2) - 5
	crossair.position.y = (get_viewport().size.y / 2) - 5
	crossair2.position.x = (get_viewport().size.x / 2) - 5
	crossair2.position.y = (get_viewport().size.y / 2) - 5

func primary_picked():
	primary_picked_bool = true
	primaries.position.y = -10
	if secondary_picked_bool:
		get_tree().change_scene_to_file("res://world.tscn")
		
func secondary_picked():
	secondary_picked_bool = true
	secondaries.position.y = -10
	if primary_picked_bool:
		get_tree().change_scene_to_file("res://world.tscn")
		
	

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
		global.secondary_weapon_path = "res://Scenes/Weapons/gun.tscn"
		secondary_picked()


func _on_play_poison_body_entered(body):
	if body.name == "Player":
		global.secondary_weapon_path = "res://Scenes/Weapons/poison_flask.tscn"
		secondary_picked()
