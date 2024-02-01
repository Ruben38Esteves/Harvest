extends Node3D

@onready var gun_anim = $AnimationPlayer
@onready var gun_barrel = $gun_barrel
@onready var fire_rate_timer = $fire_rate_gun
@onready var player = $"../../../../.."
@onready var secondaryAmmoDisplay = $"../../../../../../../UI/Hud/Ammo/Secondary"

#stats
var gunAmmo = 20
var magazineAmmo = 8
var magazineAmmoMax = 8
var can_fire_gun = true
var damage = 25.0
var base_damage = 25.0
var fire_rate = 10.0
var base_fire_rate = 10.0


var bullet = load("res://Scenes/Bullets/bullet.tscn")
var instance

# Called when the node enters the scene tree for the first time.
func _ready():
	fire_rate_timer.wait_time = 1.0 / fire_rate
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
		instance = bullet.instantiate()
		instance.position = aim.global_position
		instance.transform.basis = aim.global_transform.basis
		player.get_parent().add_child(instance)
	
		
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
	secondaryAmmoDisplay.text = str(magazineAmmo) + "/" + str(gunAmmo)
	
func increase_ammo():
	gunAmmo += 8
	update_gun_ammo_display()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Shoot" and magazineAmmo == 0 and gunAmmo > 0:
		reload()
		
func update_stats():
	damage = base_damage * (1.0 + (Inventory.gun_damage / 10.0))
