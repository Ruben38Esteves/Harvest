extends State

@onready var parent: zombie = $"../.."

func enter(last_state: String) -> void:
	parent.next_nav_point = null
	parent.attacking = true
	parent.animation_player.play("Attack")
	
func update(delta: float) -> void:
	if not parent.attacking:
		state_machine.change_state("IdleState")
	parent.velocity = Vector3.ZERO
	
