class_name Hitbox

extends Area3D

@export var parent: CharacterBody3D
@export var one_hit: bool
var player_hit: bool = false

func reset_player_hit() -> void:
	player_hit = false

func _on_body_entered(body):
	if body is Player:
		if one_hit and player_hit:
			return
		body.hit(10.0)
