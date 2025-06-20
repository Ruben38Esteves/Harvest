class_name zombie

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
var attacking: bool = false

#signals
signal zombie_hit
signal zombie_killed


@onready var nav_agent =$NavigationAgent3D
@onready var enemy_health_bar = $EnemyHealthBar
const blood_particles = preload("res://Scenes/Models/blood_particles.tscn")
@onready var status_effects = $StatusEffects
#new model
@onready var body = $Body
@onready var animation_player = $Body/AnimationPlayer

#coins utils
const COINS = preload("res://Scenes/Interactables/Items/coins.tscn")
var instance



func _ready():
	#state_machine = animation_tree.get("parameters/playback")
	enemy_health_bar.set_max_health(health)
	enemy_health_bar.set_health(health)
	animation_player.play("Idle")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(delta):
	velocity
	move_and_slide()
	
func _target_in_range():
	return global_position.distance_to(global.player.global_position) < ATTACK_RANGE
	
func _attack_finished():
	if global_position.distance_to(global.player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(global.player.global_position).normalized()
		dir.y = 0
		global.player.hit(dir,ATTACK_KNOCKBACK,damage)
	
	
# zombie attacked
func hit(dmg, hit_location = position, status: Array = []):
	if health == max_health:
		enemy_health_bar.visible = true
	health -= dmg
	emit_signal("zombie_hit")
	enemy_health_bar.set_health(health)
	spawn_blood(hit_location)
	if health <= 0:
		if !dead:
			dead = true
			emit_signal("zombie_killed")
			instance = COINS.instantiate()
			instance.position = self.global_position
			self.get_parent().add_child(instance)
			queue_free()
	else:
		#sprite.modulate = Color.DARK_RED
		await get_tree().create_timer(0.1).timeout
		#sprite.modulate = Color.WHITE
		
		for effect in status:
			status_effects.apply_status(effect)
		

func spawn_blood(hit_location):
	var blood = blood_particles.instantiate()
	add_child(blood)
	blood.global_transform.origin = hit_location
	blood.emitting = true

func pushed(dir, knockback):
	velocity += dir * knockback
	
func play_animation(animation_name: String) -> void:
	animation_player.play(animation_name)

func chase_player() -> void:
	nav_agent.set_target_position(global.player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	look_at(Vector3(next_nav_point.x,global_position.y,next_nav_point.z))
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
#func apply_status(status: String) -> void:
	#if statuses.has(status):
		#statuses[status].activate()
