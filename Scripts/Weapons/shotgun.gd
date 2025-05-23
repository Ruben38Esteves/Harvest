class_name shotgun
extends gun

var bullet = load("res://Scenes/Bullets/bullet_shotgun.tscn")
var instance

@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer


@export var bullet_amount = 4
const spread = deg_to_rad(8)
var aim_value = null

# animation tree conditions
var reload_finished = false
var is_reloading = false
var is_shooting = false


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
	if !animation_player.is_playing() and can_fire_gun and magazineAmmo > 0:
		is_shooting = true
		aim_value = aim
		
		
func shoot_aux():
	magazineAmmo -= 1
	can_fire_gun = false
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
	update_gun_ammo_display()
	
func reload():
	if !animation_player.is_playing() and magazineAmmo < magazineAmmoMax and gunAmmo > 0:
		is_reloading = true
		reload_finished = false
		
func add_bullet():
	if magazineAmmo < magazineAmmoMax and gunAmmo > 0:
		gunAmmo -= 1
		magazineAmmo += 1
		update_gun_ammo_display()
	if magazineAmmo >= magazineAmmoMax or gunAmmo <= 0:
		reload_finished = true
		is_reloading = false

func _on_fire_rate_timeout():
	can_fire_gun = true

	
func increase_ammo():
	gunAmmo += 4
	update_gun_ammo_display()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shoot" and magazineAmmo == 0 and gunAmmo > 0:
		reload()
