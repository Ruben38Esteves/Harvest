extends Node

var player: Player
var inventory: inventory
var debug


var primary_weapon_path = "res://Weapons/Shotgun/shotgun.tscn"
var secondary_weapon_path = "res://Weapons/HandGun/hand_gun.tscn"
var meelee_weapon_path = "res://Weapons/Axe/axe.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _set(property, value):
	property = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
