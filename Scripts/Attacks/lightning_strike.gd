class_name lightning_strike
extends RigidBody3D

func set_target(pos: Vector3) -> void:
	var distance: Vector3 = pos - global_position
	var duration := 0.1
	linear_velocity = distance / duration
