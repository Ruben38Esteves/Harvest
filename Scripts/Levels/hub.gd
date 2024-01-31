extends Node3D

@onready var crossair = $UI/crossair
@onready var crossair2 = $UI/crossair2

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


func _on_play_shotgun_body_entered(body):
	if body.name == "Player":
		global.primary_weapon_path = "res://Scenes/Weapons/shotgun.tscn"
		get_tree().change_scene_to_file("res://world.tscn")


func _on_play_rifle_body_entered(body):
	if body.name == "Player":
		global.primary_weapon_path = "res://Scenes/Weapons/rifle.tscn"
		get_tree().change_scene_to_file("res://world.tscn")
