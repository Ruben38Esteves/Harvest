extends RigidBody3D

var thrown = false
@onready var poison_flask = $poison_flask
@onready var collision_shape = $CollisionShape3D
@onready var ray = $RayCast3D
var poison_pool = load("res://Scenes/Weapons/poison_pool.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if thrown and ray.is_colliding():
		var collision_point = ray.get_collision_point()
		var new_poison_pool = poison_pool.instantiate()
		new_poison_pool.position = global_position
		new_poison_pool.position.y = collision_point.y
		get_parent().add_child(new_poison_pool)
		queue_free()


func _on_timer_timeout():
	thrown = true;
