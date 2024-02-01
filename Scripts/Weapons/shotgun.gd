extends Node3D

var bullet = load("res://Scenes/Bullets/bullet_shotgun.tscn")
var instance

@onready var animation_player = $AnimationPlayer
@onready var fire_rate_timer = $fire_rate
@onready var player = $"../../../../.."
@onready var primaryAmmoDisplay = $"../../../../../../../UI/Hud/Ammo/Primary"

var can_fire = true

#stats
var ammo = 10
var magazineAmmo = 6
var magazineAmmoMax = 6
var bullet_amount = 4
const spread = deg_to_rad(8)
var base_fire_rate = 0.8
var fire_rate = 0.8
var base_damage = 20.0
var damage = 20.0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_ammo_display()
	fire_rate_timer.wait_time = 1.0 / 0.8


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(aim):
	if !animation_player.is_playing() and can_fire and magazineAmmo > 0:
		magazineAmmo -= 1
		can_fire = false
		fire_rate_timer.start()
		animation_player.play("shoot")
		shoot_bullets(aim)
		
	
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
		instance.damage = damage
		player.get_parent().add_child(instance)
		dir.rotation.x = old_rot_x
		dir.rotation.y = old_rot_y
	update_ammo_display()
	
func reload():
	if !animation_player.is_playing() and magazineAmmo < magazineAmmoMax and ammo > 0:
		animation_player.play("reload")
		var ammoNeeded = magazineAmmoMax - magazineAmmo
		if ammo < ammoNeeded:
			magazineAmmo += ammo
			ammo = 0
		else:
			ammo -= magazineAmmoMax - magazineAmmo
			magazineAmmo = magazineAmmoMax
		update_ammo_display()

func _on_fire_rate_timeout():
	can_fire = true

func update_ammo_display():
	primaryAmmoDisplay.text = str(magazineAmmo) + "/" + str(ammo)
	
func increase_ammo():
	ammo += 4
	update_ammo_display()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shoot" and magazineAmmo == 0 and ammo > 0:
		reload()
		
func update_stats():
	damage = base_damage + (base_damage * (Inventory.gun_damage / 10))
