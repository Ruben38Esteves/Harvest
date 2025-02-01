class_name IdleMovementState

extends State


func update(delta):
	if global.player.velocity.length() > 0.0 and global.player.is_on_floor():
		transition.emit("WalkingMovementState")
