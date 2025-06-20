extends State

@onready var parent: zombie = $"../.."


func enter(last_state: String) -> void:
	parent.play_animation("Run")
	
func update(delta: float) -> void:
	parent.chase_player()
	if parent._target_in_range():
		state_machine.change_state("AttackState")
