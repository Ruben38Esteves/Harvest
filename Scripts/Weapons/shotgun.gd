extends Node3D

var bullet = load("res://Scenes/Bullets/bullet_shotgun.tscn")
var instance

@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var fire_rate_timer = $fire_rate
@onready var player = $"../../../../.."
@onready var primaryAmmoDisplay = $"../../../../../../../UI/Hud/Ammo/Primary"


var can_fire = true
var ammo = 10
var magazineAmmo = 4
var magazineAmmoMax = 6
var bullet_amount = 4
const spread = deg_to_rad(8)
var fire_rate = 0.8
var aim_value = null

# animation tree conditions
var reload_finished = false
var is_reloading = false
var is_shooting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	update_ammo_display()
	fire_rate_timer.wait_time = 1 / 0.8

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animation_tree.set("parameters/conditions/is_shooting", is_shooting)
	animation_tree.set("parameters/conditions/reload_finished", reload_finished)
	animation_tree.set("parameters/conditions/reload_not_finished", !(reload_finished))
	animation_tree.set("parameters/conditions/reload_finished_2", reload_finished)
	animation_tree.set("parameters/conditions/reload_not_finished_2", !(reload_finished))
	animation_tree.set("parameters/conditions/is_reloading", is_reloading)
	animation_tree.get("parameters/playback")
	is_shooting = false

func shoot(aim):
	if !animation_player.is_playing() and can_fire and magazineAmmo > 0:
		is_shooting = true
		aim_value = aim
		
		
func shoot_aux():
	magazineAmmo -= 1
	can_fire = false
	fire_rate_timer.start()
	shoot_bullets(aim_value)
	if magazineAmmo == 0:
		reload()
	
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
	
func reload():
	if !animation_player.is_playing() and magazineAmmo < magazineAmmoMax and ammo > 0:
		is_reloading = true
		reload_finished = false
		
func add_bullet():
	if magazineAmmo < magazineAmmoMax and ammo > 0:
		ammo -= 1
		magazineAmmo += 1
		update_ammo_display()
	if magazineAmmo >= magazineAmmoMax or ammo <= 0:
		reload_finished = true
		is_reloading = false

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
