class_name poison_flask_weapon

extends gun
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var poison_flask_visual = $poison_flask
var can_fire = true
var poison_flask = load("res://Weapons/PoisonFlask/poison_flask_object.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(gun_aim: RayCast3D):
	if can_fire and gunAmmo > 0:
		animation_player.play("RESET")
		can_fire = false
		fire_rate_timer.start()
		gunAmmo -= 1
		update_gun_ammo_display()
		poison_flask_visual.visible = false
		var flask = poison_flask.instantiate()
		flask.position = gun_aim.global_position
		player.get_parent().add_child(flask)
		var impulse = gun_aim.global_transform.basis.z.normalized()
		impulse.x = impulse.x * 1.5
		impulse.z = impulse.z * 1.5
		flask.apply_impulse(impulse * -5.0 + Vector3(0,1.5,0))
		
func hold():
	if can_fire and gunAmmo > 0:
		animation_player.play("hold")
	
func reload():
	pass

func _on_fire_rate_timeout():
	can_fire = true
	poison_flask_visual.visible = true
	
func increase_ammo():
	gunAmmo += 4
	update_gun_ammo_display()
