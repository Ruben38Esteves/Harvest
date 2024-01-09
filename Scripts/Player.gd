extends CharacterBody3D

#movement
var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 7.5

#fov
const BASE_FOV = 75
const FOV_CHANGE = 1.1

const JUMP_VELOCITY = 7
const SENSITIVITY = 0.003

#bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

#signals
signal player_hit

#bullets
var bullet = load("res://Scenes/bullet.tscn")
var instance


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_3d = $Head/Camera3D
@onready var head = $Head
@onready var gun_anim = $Head/Camera3D/Gun/AnimationPlayer
@onready var gun_barrel = $Head/Camera3D/Gun/gun_barrel


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
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
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
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
	if Input.is_action_pressed("attack"):
		if !gun_anim.is_playing():
			gun_anim.play("Shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)

	move_and_slide()
	
func _head_bob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
func hit(dir,knockback):
	emit_signal("player_hit")
	velocity += dir * knockback
	

	
