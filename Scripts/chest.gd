extends Node3D

signal chest_opened
@onready var glow = $glow
@onready var shader = $body.material.next_pass
@onready var price_tag = $SubViewport/Label

var price = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	price_tag.text = str(price) + "g"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func open_chest(money):
	if money >= price:
		shader.set_shader_parameter("strength", 0.0)
		queue_free()
		return money - price
	else:
		return money

func _on_body_chest_used():
	shader.set_shader_parameter("strength", 0.0)
	queue_free()
	
