class_name WalkingMovementState

extends State

func enter() -> void:
	global.player.speed = global.player.WALK_SPEED

func update(delta):
	if global.player.velocity.length() == 0.0:
		transition.emit("IdleMovementState")
	if Input.is_action_pressed("sprint") and !Input.is_action_pressed("back") and !Input.is_action_pressed("crouch") and global.player.is_on_floor():
		transition.emit("SprintMovementState")
"""
func _input(event):
	if event.is_action_pressed("sprint") and !event.is_action_pressed("back") and !event.is_action_pressed("crouch") and global.player.is_on_floor():
		transition.emit("SprintMovementState")
"""		
