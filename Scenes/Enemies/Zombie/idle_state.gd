extends State

@onready var parent: zombie = $"../.."
@onready var state_machine: StateMachine = $".."

func enter(last_state: String) -> void:
	#parent.play_animation("Idle")
	pass
	
func update(delta: float) -> void:
	parent.velocity = Vector3.ZERO
	if parent.global_position.distance_to(global.player.global_position) < 5.0:
		state_machine.change_state("RunState")
