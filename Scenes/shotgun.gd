extends Node3D

var bullet = load("res://Scenes/bullet_shotgun.tscn")
var instance

@onready var animation_player = $AnimationPlayer
@onready var fire_rate = $fire_rate
@onready var player = $"../../../../.."
@onready var primaryAmmoDisplay = $"../../../../../../../UI/Hud/Ammo/Primary"

var can_fire = true
var ammo = 10
var bullet_amount = 3
const spread = deg_to_rad(8)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_ammo_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(aim):
	print("shotgun shoot")
	if !animation_player.is_playing() and can_fire and ammo > 0:
		ammo -= 1
		can_fire = false
		fire_rate.start()
		animation_player.play("shoot")
		shoot_bullets(aim)

func _on_fire_rate_timeout():
	can_fire = true
	
func shoot_bullets(aim):
	var dir = aim
	var old_rot_x = dir.rotation.x
	var old_rot_y = dir.rotation.y
	for i in bullet_amount:
		instance = bullet.instantiate()
		instance.position = dir.global_position
		dir.rotation.x = randf_range(spread, -spread)
		dir.rotation.y = randf_range(spread, -spread)
		instance.transform.basis = dir.global_transform.basis
		player.get_parent().add_child(instance)
		dir.rotation.x = old_rot_x
		dir.rotation.y = old_rot_y
	update_ammo_display()

func update_ammo_display():
	primaryAmmoDisplay.text = str(ammo)
	
func increase_ammo():
	ammo += 4
	update_ammo_display()
