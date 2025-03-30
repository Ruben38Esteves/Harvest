class_name StateMachine

extends Node

@export var CURRENT_STATE : State
var states: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			#child.transition.connect(on_child_transition)
		else:
			push_warning("State machine contains invalid child node")
	CURRENT_STATE.enter()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	CURRENT_STATE.update(delta)
	global.debug.add_debug_property("State", CURRENT_STATE.name, 1)
	
func _physics_process(delta: float) -> void:
	CURRENT_STATE.physics_process(delta)

func change_state(new_state_name: StringName) -> void:
	print(new_state_name)
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != CURRENT_STATE:
			CURRENT_STATE.exit()
			new_state.enter()
			CURRENT_STATE = new_state
		else:
			print("same state")
	else:
		print("state is null")
