class_name gun

extends Node3D

@onready var gun_anim = $AnimationPlayer
@onready var fire_rate_timer = $fire_rate_gun
var player = null
@export var type = "primary"
@export var damage = 25
@export var range = 100
@export var gunAmmo = 20
@export var magazineAmmo = 8
@export var magazineAmmoMax = 8
@export var fire_rate = 1
var can_fire_gun = true


# Called when the node enters the scene tree for the first time.
func _ready():
	fire_rate_timer.wait_time = 1 / fire_rate
	player = global.player
	update_gun_ammo_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func shoot(aim):
	if !gun_anim.is_playing() and can_fire_gun and magazineAmmo > 0:
		magazineAmmo -= 1
		update_gun_ammo_display()
		can_fire_gun = false
		fire_rate_timer.start()
		gun_anim.play("Shoot")
		if aim.is_colliding():
			var target = aim.get_collider()
			if target.is_in_group("enemy"):
				target.attacked(damage,aim.get_collision_point())

		
func reload():
	if !gun_anim.is_playing() and gunAmmo > 0 and magazineAmmo < magazineAmmoMax:
		gun_anim.play("reload")
		var ammoNeeded = magazineAmmoMax - magazineAmmo
		if gunAmmo < ammoNeeded:
			magazineAmmo += gunAmmo
			gunAmmo = 0
		else:
			gunAmmo -= magazineAmmoMax - magazineAmmo
			magazineAmmo = magazineAmmoMax
		update_gun_ammo_display()


func _on_fire_rate_gun_timeout():
	can_fire_gun = true
	
func update_gun_ammo_display():
	global.player.ui.update_ammo_display(type, magazineAmmo, gunAmmo)
	
func increase_ammo():
	gunAmmo += 8
	update_gun_ammo_display()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Shoot" and magazineAmmo == 0 and gunAmmo > 0:
		reload()
