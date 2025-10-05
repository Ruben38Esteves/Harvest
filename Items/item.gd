class_name item

extends RigidBody3D

@onready var ground_checker = $GroundChecker
@onready var animation_player = $AnimationPlayer
@onready var glow: OmniLight3D = $Glow
@onready var visual = $Visual

@export var light: Color = Color(1.0,1.0,0.0)
const OUTLINE = preload("res://Terrain/Interactables/Outline/outline.tres")

func _ready() -> void:
	apply_impulse(Vector3((randf()*2)-1,2,(randf()*2)-1),position)
	glow.light_color = light
	var mesh =  visual.get_child(0)
	if mesh:
		#OUTLINE.set_shader_parameter("outline_color", light)
		mesh.material_overlay = OUTLINE

func _process(delta):
	if ground_checker.is_colliding():
		freeze = true
		animation_player.play("float")

func _on_collectible_area_body_entered(body):
	if body.is_in_group("player"):
		body.get_item(get_parent().item_type, get_parent().item_description)
		get_parent().queue_free()
