extends Node3D


@onready var player = $"../../../../.."
@onready var secondaryAmmoDisplay = $"../../../../../../../UI/Hud/Ammo/Secondary"
@onready var fire_rate_timer = $fire_rate
@onready var poison_flask_visual = $poison_flask

var can_fire = true
var fire_rate = 0.75
var ammo = 10

var poison_flask = load("res://Scenes/Weapons/poison_flask_object.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	fire_rate_timer.wait_time = 1.0 / fire_rate


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(gun_aim):
	if can_fire and ammo > 0:
		can_fire = false
		fire_rate_timer.start()
		ammo -= 1
		poison_flask_visual.visible = false
		var flask = poison_flask.instantiate()
		flask.position = gun_aim.global_position
		flask.transform.basis = gun_aim.global_transform.basis
		player.get_parent().add_child(flask)
		flask.linear_velocity = Vector3.ZERO
		flask.apply_impulse(gun_aim.global_transform.basis.z * -5.0)
	
func reload():
	pass

func _on_fire_rate_timeout():
	can_fire = true
	poison_flask_visual.visible = true

func update_ammo_display():
	secondaryAmmoDisplay.text = str(ammo)
	
func increase_ammo():
	ammo += 4
	update_ammo_display()
