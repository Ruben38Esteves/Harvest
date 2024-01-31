extends Node3D

#consts
@onready var coins_anim_player = $AnimationPlayer
@onready var collectible = $Collectible
@onready var collectible_range = $Collectible/CollectibleRange
@onready var static_body_3d = $StaticBody3D
var has_spawned = false

#money
var value = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	coins_anim_player.play("float")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_collectible_body_entered(body):
	body.get_money(10)
	queue_free()
