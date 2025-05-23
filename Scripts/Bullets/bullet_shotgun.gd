extends Node3D

@onready var ray = $RayCast3D
@onready var mesh = $bullet
@onready var particles = $GPUParticles3D

const speed = 30.0
var damage = 20.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0,0,-speed) * delta
	if ray.is_colliding():
		ray.enabled = false
		mesh.visible = false
		particles.emitting = true
		if ray.get_collider().is_in_group("enemy") :
			ray.get_collider().attacked(damage,ray.get_collision_point())
		#await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_timer_timeout():
	queue_free()
