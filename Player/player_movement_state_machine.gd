extends StateMachine

func _process(delta: float) -> void:
	CURRENT_STATE.update(delta)
	global.debug.add_debug_property("State", CURRENT_STATE.name, 1)
