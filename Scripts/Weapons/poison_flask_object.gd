extends RigidBody3D

var thrown = false
@onready var poison_flask = $poison_flask
@onready var collision_shape = $CollisionShape3D
var poison_pool = load("res://Scenes/Weapons/poison_pool.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if linear_velocity.y != 0:
		thrown = true
	if thrown and linear_velocity.y == 0:
		var new_poison_pool = poison_pool.instantiate()
		new_poison_pool.position = global_position
		get_parent().add_child(new_poison_pool)
		queue_free()
