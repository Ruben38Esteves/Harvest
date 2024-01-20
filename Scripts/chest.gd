extends Node3D

signal chest_opened
@onready var glow = $glow
@onready var shader = $body.material.next_pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_chest_used():
	shader.set_shader_parameter("strength", 0.0)
	queue_free()
	
