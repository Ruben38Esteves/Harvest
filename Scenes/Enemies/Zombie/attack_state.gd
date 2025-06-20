extends State

@onready var parent: zombie = $"../.."

func enter(last_state: String) -> void:
	parent.attacking = true
	parent.animation_player.play("Attack")
	
func update(delta: float) -> void:
	if not parent.attacking:
		state_machine.change_state("RunState")
	parent.velocity = Vector3.ZERO
	
