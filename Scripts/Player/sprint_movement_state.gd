class_name SprintMovementState

extends State


# Called when the node enters the scene tree for the first time.
func enter() -> void:
	global.player.speed = global.player.SPRINT_SPEED

func _input(event):
	if event.is_action_released("sprint") or event.is_action_pressed("back") or event.is_action_pressed("crouch") or !global.player.is_on_floor():
		transition.emit("WalkingMovementState")
