extends Node3D

@onready var rifle_anim = $AnimationPlayerRifle
@onready var rifle_barrel = $rifle_barrel
@onready var fire_rate_timer = $fire_rate_timer
@onready var player = $"../../../../.."
@onready var primaryAmmoDisplay = $"../../../../../../../UI/Hud/Ammo/Primary"
var can_fire = true

#stats
var rifleAmmo = 10
var base_fire_rate = 1.0
var fire_rate = 1.0
var base_damage = 65.0
var damage = 65.0


var bullet = load("res://Scenes/Bullets/bullet_rifle.tscn")
var instance

# Called when the node enters the scene tree for the first time.
func _ready():
	update_rifle_ammo_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fire_rate_timer.wait_time = 1 / fire_rate
	
func shoot(aim):
	if !rifle_anim.is_playing() and can_fire and rifleAmmo > 0:
		rifleAmmo -= 1
		rifle_anim.play("shoot")
		update_rifle_ammo_display()
		can_fire = false
		fire_rate_timer.start()
		instance = bullet.instantiate()
		instance.position = aim.global_position
		instance.transform.basis = aim.global_transform.basis
		instance.damage = damage
		player.get_parent().add_child(instance)

func reload():
	pass
	
func _on_fire_rate_timer_timeout():
	can_fire = true
	
func update_rifle_ammo_display():
	primaryAmmoDisplay.text = str(rifleAmmo)
	
func increase_ammo():
	rifleAmmo += 4
	update_rifle_ammo_display()
	
func update_stats():
	damage = base_damage + (base_damage * (Inventory.gun_damage / 10))
