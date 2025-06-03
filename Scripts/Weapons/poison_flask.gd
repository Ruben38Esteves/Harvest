class_name poison_flask_weapon

extends gun

@onready var poison_flask_visual = $poison_flask
var can_fire = true
var poison_flask = load("res://Scenes/Weapons/poison_flask_object.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(gun_aim):
	if can_fire and gunAmmo > 0:
		can_fire = false
		fire_rate_timer.start()
		gunAmmo -= 1
		update_gun_ammo_display()
		poison_flask_visual.visible = false
		var flask = poison_flask.instantiate()
		flask.position = gun_aim.global_position
		flask.transform.basis = gun_aim.global_transform.basis
		player.get_parent().add_child(flask)
		flask.linear_velocity = Vector3.ZERO + player.velocity
		flask.apply_impulse(gun_aim.global_transform.basis.z * -5.0)
	
func reload():
	pass

func _on_fire_rate_timeout():
	can_fire = true
	poison_flask_visual.visible = true
	
func increase_ammo():
	gunAmmo += 4
	update_gun_ammo_display()
