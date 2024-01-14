extends Node3D

@onready var rifle_anim = $AnimationPlayerRifle
@onready var rifle_barrel = $rifle_barrel
@onready var fire_rate = $fire_rate
@onready var player = $"../../.."
var can_fire = true

#stats
var damage := 2


var bullet = load("res://Scenes/bullet_rifle.tscn")
var instance

# Called when the node enters the scene tree for the first time.
func _ready():
	player.fire_rifle.connect(_on_player_fire_rifle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_fire_rifle():
	if !rifle_anim.is_playing() and can_fire:
		can_fire = false
		fire_rate.start()
		rifle_anim.play("shoot")
		instance = bullet.instantiate()
		instance.position = rifle_barrel.global_position
		instance.transform.basis = rifle_barrel.global_transform.basis
		player.get_parent().add_child(instance)


func _on_fire_rate_timeout():
	can_fire = true
