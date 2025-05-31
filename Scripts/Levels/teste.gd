extends Node3D

var instance = null

func _ready() -> void:
	spawn_player_weapons()

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
