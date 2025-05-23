extends CharacterBody3D

#stats
const SPEED = 4.0
const JUMP_VELOCITY = 4.5
const ATTACK_RANGE = 1.5
var max_health = 100
var health = 100
const ATTACK_KNOCKBACK = 10.0
var damage = 10
var dead: bool = false

#signals
signal zombie_hit
signal zombie_killed

@onready var status_effects = $StatusEffects
@onready var nav_agent =$NavigationAgent3D
@onready var anim_tree = $AnimationTree
@onready var progress_bar = $SubViewport/ProgressBar
@onready var sprite = $Sprite3D
@onready var health_bar = $health_bar
const blood_particles = preload("res://Scenes/Models/blood_particles.tscn")

#coins utils
const COINS = preload("res://Scenes/Interactables/Items/coins.tscn")
var instance

var state_machine
@export var attacking: bool = false

func _ready():
	state_machine = anim_tree.get("parameters/playback")
	progress_bar.max_value = health
	progress_bar.value = health

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(delta):
	velocity
	match state_machine.get_current_node():
		"walk":
			nav_agent.set_target_position(global.player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		"attack":
			velocity = Vector3.ZERO
	
	anim_tree.set("parameters/conditions/attack", _target_in_range())
	anim_tree.set("parameters/conditions/walk", !_target_in_range())
	
	anim_tree.get("parameters/playback")
	move_and_slide()
	
func _target_in_range():
	return global_position.distance_to(global.player.global_position) < ATTACK_RANGE
	
func _attack_finished():
	if global_position.distance_to(global.player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(global.player.global_position).normalized()
		dir.y = 0
		global.player.hit(dir,ATTACK_KNOCKBACK,damage)
	
		
# zombie was attacked
#func _on_area_3d_body_hit(dmg):
	#if health == max_health:
		#health_bar.visible = true
	#health -= dmg
	#emit_signal("zombie_hit")
	#progress_bar.value = health
	#if health <= 0:
		#print("i died B")
		#emit_signal("zombie_killed")
		#instance = COINS.instantiate()
		#instance.position = self.global_position
		#self.get_parent().add_child(instance)
		#queue_free()
	#sprite.modulate = Color.DARK_RED
	#await get_tree().create_timer(0.1).timeout
	#sprite.modulate = Color.WHITE
	
# zombie attacks
func attacked(dmg, hit_location = position):
	if health == max_health:
		health_bar.visible = true
	health -= dmg
	emit_signal("zombie_hit")
	progress_bar.value = health
	spawn_blood(hit_location)
	if health <= 0:
		if !dead:
			dead = true
			print("i died")
			emit_signal("zombie_killed")
			instance = COINS.instantiate()
			instance.position = self.global_position
			self.get_parent().add_child(instance)
			queue_free()
	else:
		sprite.modulate = Color.DARK_RED
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = Color.WHITE

func spawn_blood(hit_location):
	var blood = blood_particles.instantiate()
	add_child(blood)
	blood.global_transform.origin = hit_location
	blood.emitting = true

func pushed(dir, knockback):
	velocity += dir * knockback
