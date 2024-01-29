extends CharacterBody3D

#stats
const SPEED = 4.0
const JUMP_VELOCITY = 4.5
const ATTACK_RANGE = 2.5
var health = 3
const ATTACK_KNOCKBACK = 10.0
var damage = 10

#signals
signal zombie_hit
signal zombie_killed

var player = null

@export var player_path := "/root/world/map/Player"

@onready var nav_agent =$NavigationAgent3D
@onready var anim_tree = $AnimationTree
@onready var progress_bar = $SubViewport/ProgressBar
@onready var sprite = $Sprite3D

#coins utils
const COINS = preload("res://Scenes/coins.tscn")
var instance

var state_machine

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	progress_bar.max_value = health
	progress_bar.value = health

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
		player.hit(dir,ATTACK_KNOCKBACK,damage)
	
		

func _on_area_3d_body_hit(dmg):
	health -= dmg
	emit_signal("zombie_hit")
	progress_bar.value = health
	if health <= 0:
		emit_signal("zombie_killed")
		instance = COINS.instantiate()
		instance.position = self.global_position
		self.get_parent().add_child(instance)
		queue_free()
	sprite.modulate = Color.DARK_RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

func attacked(dmg):
	health -= dmg
	emit_signal("zombie_hit")
	progress_bar.value = health
	if health <= 0:
		emit_signal("zombie_killed")
		instance = COINS.instantiate()
		instance.position = self.global_position
		self.get_parent().add_child(instance)
		queue_free()
