extends State

@onready var parent: zombie = $"../.."
var time_passed = 0.0
func enter(last_state: String) -> void:
	parent.next_nav_point = null
	time_passed = 0.0
	
func update(delta: float) -> void:
	parent.velocity = Vector3.ZERO
	time_passed += delta
	if parent.global_position.distance_to(global.player.global_position) < 5.0:
		state_machine.change_state("RunState")
	if time_passed > 3.0:
		state_machine.change_state("WalkState")
