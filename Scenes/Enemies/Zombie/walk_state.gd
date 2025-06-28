extends State

@onready var parent: zombie = $"../.."

func enter(last_state: String) -> void:
	var nav_map = parent.get_world_3d().navigation_map
	var random_point = NavigationServer3D.map_get_random_point(nav_map, 1, false)
	parent.next_nav_point = random_point
	parent.animation_player.play("Walk")
	parent.speed = parent.WALK_SPEED
	
func update(delta: float) -> void:
	if parent.hurt:
		state_machine.change_state("RunState")
	if parent.global_position.distance_to(global.player.global_position) < 10.0:
		state_machine.change_state("RunState")
	if parent.global_position.distance_to(parent.next_nav_point) <= 1.0:
		state_machine.change_state("IdleState")
