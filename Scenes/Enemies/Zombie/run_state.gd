extends State

@onready var parent: zombie = $"../.."
@onready var state_machine: StateMachine = $".."

func enter(last_state: String) -> void:
	parent.play_animation("Run")
	
func update(delta: float) -> void:
	parent.chase_player()
