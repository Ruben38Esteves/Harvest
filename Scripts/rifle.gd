extends Node3D

@onready var rifle_anim = $AnimationPlayerRifle
@onready var rifle_barrel = $rifle_barrel
@onready var fire_rate = $fire_rate
@onready var player = $"../../../../.."
@onready var primaryAmmoDisplay = $"../../../../../../../UI/Hud/Ammo/Primary"
var rifleAmmo = 10
var can_fire = true

#stats
var damage := 2


var bullet = load("res://Scenes/bullet_rifle.tscn")
var instance

# Called when the node enters the scene tree for the first time.
func _ready():
	update_rifle_ammo_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func shoot(aim):
	if !rifle_anim.is_playing() and can_fire and rifleAmmo > 0:
		rifleAmmo -= 1
		update_rifle_ammo_display()
		can_fire = false
		fire_rate.start()
		rifle_anim.play("shoot")
		instance = bullet.instantiate()
		instance.position = aim.global_position
		instance.transform.basis = aim.global_transform.basis
		player.get_parent().add_child(instance)


func _on_player_fire_rifle():
	if !rifle_anim.is_playing() and can_fire and rifleAmmo > 0:
		rifleAmmo -= 1
		update_rifle_ammo_display()
		can_fire = false
		fire_rate.start()
		rifle_anim.play("shoot")
		instance = bullet.instantiate()
		instance.position = rifle_barrel.global_position
		instance.transform.basis = rifle_barrel.global_transform.basis
		player.get_parent().add_child(instance)


func _on_fire_rate_timeout():
	can_fire = true
	
func update_rifle_ammo_display():
	primaryAmmoDisplay.text = str(rifleAmmo)

func _on_player_increase_rifle_ammo():
	rifleAmmo += 4
	update_rifle_ammo_display()
	
func increase_ammo():
	rifleAmmo += 4
	update_rifle_ammo_display()
