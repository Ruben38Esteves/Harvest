extends CharacterBody3D


const SPEED = 4.0
const JUMP_VELOCITY = 4.5
const ATTACK_RANGE = 2.5
var health = 3

const ATTACK_KNOCKBACK = 10.0

var player = null

@export var player_path := "/root/world/map/Player"

@onready var nav_agent =$NavigationAgent3D

@onready var anim_tree = $AnimationTree
var state_machine

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(delta):
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"walk":
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		"attack":
			pass
	
	
	anim_tree.set("parameters/conditions/attack", _target_in_range())
	anim_tree.set("parameters/conditions/walk", !_target_in_range())
	
	anim_tree.get("parameters/playback")
	move_and_slide()
	
func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func _attack_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1:
		var dir = global_position.direction_to(player.global_position).normalized()
		dir.y = 0
		player.hit(dir,ATTACK_KNOCKBACK)
	
		

func _on_area_3d_body_hit(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
