extends CharacterBody3D

#movement
var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 7.5
const JUMP_VELOCITY = 7
const SENSITIVITY = 0.003
var doublejump = true

#fov
const BASE_FOV = 75
const FOV_CHANGE = 1.1

#bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_3d = $Head/Camera3D
@onready var head = $Head
@onready var gun_aim = $Head/Camera3D/gun_aim

#stats
@onready var health_bar = $"../../UI/Hud/HealthBar"
signal player_hit
var maxHealth = 100
var health = 100

#money
var money = 0


#guns
var current_gun = "fire_rifle"
#pistol
signal fire_gun
signal increase_gun_ammo
@onready var gun = $Head/Camera3D/Gun
#rifle
signal fire_rifle
signal increase_rifle_ammo
@onready var rifle = $Head/Camera3D/Rifle

#utils
var looking_at = null


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	current_gun = "fire_rifle"
	gun.visible = false
	rifle.visible = true
	update_progress_bar()
	
	
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera_3d.rotate_x(-event.relative.y * SENSITIVITY)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * 1.5

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			doublejump = true
		elif doublejump:
			velocity.y = JUMP_VELOCITY
			doublejump = false
	
	
	#sprint
	if Input.is_action_pressed("sprint") and !Input.is_action_pressed("back"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var input_side_right = Input.is_action_pressed("right")
	var input_side_left = Input.is_action_pressed("left")
	
	#head lean
	if input_side_right:
		head.rotation_degrees.z = lerp(head.rotation_degrees.z, -2.0, delta * 5)
	elif input_side_left:
		head.rotation_degrees.z = lerp(head.rotation_degrees.z, 2.0, delta * 5)
	else:
		head.rotation_degrees.z = lerp(head.rotation_degrees.z, 0.0, delta * 5)
		
	#head rotation
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#movement
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
		
	#head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera_3d.transform.origin = _head_bob(t_bob)
	
	#fov changer
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera_3d.fov = lerp(camera_3d.fov,target_fov, delta * 8.0)
	
	#attacking
	if Input.is_action_just_pressed("attack"):
		if current_gun == "fire_rifle":
			emit_signal("fire_rifle")
		elif current_gun == "fire_gun":
			emit_signal("fire_gun")
		
	#change weapon
	if Input.is_action_just_pressed("primary"):
		current_gun = "fire_rifle"
		gun.visible = false
		rifle.visible = true
	elif Input.is_action_just_pressed("secondary"):
		current_gun = "fire_gun"
		gun.visible = true
		rifle.visible = false
		
	#menu
	if Input.is_action_just_pressed("escape"):
		player_die()
		
	#open chest
	if Input.is_action_just_pressed("interact"):
		if gun_aim.is_colliding():
			if gun_aim.get_collider().is_in_group("chest"):
				gun_aim.get_collider().used()
	
	#chest glow
	var coll = gun_aim.get_collider()
	if coll != looking_at:
		if coll != null and coll.is_in_group("chest"):
			coll.targeted = true
		if looking_at != null and looking_at.is_in_group("chest"):
			looking_at.targeted = false
		looking_at = coll
			
	move_and_slide()
	
func _head_bob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
func hit(dir,knockback,damage):
	emit_signal("player_hit")
	velocity += dir * knockback
	health -= damage
	update_progress_bar()
	
func update_progress_bar():
	health_bar.max_value = maxHealth
	health_bar.value = health
	if health <= 0:
		player_die()
	
	
func player_die():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
func _on_world_add_ammo(type):
	if type == 1:
		emit_signal("increase_rifle_ammo")
	elif type == 2:
		emit_signal("increase_gun_ammo")

func glow_chest(target_chest):
	target_chest.glow(true)
	while gun_aim.get_collider() == target_chest:
		pass
	target_chest.glow(false)
	
