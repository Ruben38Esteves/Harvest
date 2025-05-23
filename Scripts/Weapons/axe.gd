extends Node3D
@onready var axe_animation_player = $AnimationPlayer
@onready var axe_hitbox = $axe/Area3D/axe_hitbox
var damage = 70


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot():
	if !axe_animation_player.is_playing():
		axe_animation_player.play("attack")


func _on_area_3d_body_entered(body):
	#if body.is_in_group("enemy"):
	axe_animation_player.pause()
	var hit_point = axe_hitbox.global_position
	body.attacked(damage, hit_point)
	await get_tree().create_timer(0.05).timeout
	axe_animation_player.play()
