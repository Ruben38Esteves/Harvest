class_name item

extends RigidBody3D

@onready var ground_checker = $GroundChecker
@onready var animation_player = $AnimationPlayer
@onready var glow: OmniLight3D = $Glow

@export var light: Color = Color(1.0,1.0,0.0)

func _ready() -> void:
	apply_impulse(Vector3((randf()*2)-1,2,(randf()*2)-1),position)
	glow.light_color = light

func _process(delta):
	if ground_checker.is_colliding():
		freeze = true
		animation_player.play("float")

func _on_collectible_area_body_entered(body):
	if body.is_in_group("player"):
		body.get_item(get_parent().item_type)
		get_parent().queue_free()
