extends State

@onready var parent: zombie = $"../.."

func enter(last_state: String) -> void:
	var nav_map = parent.get_world_3d().navigation_map
	var random_point = NavigationServer3D.map_get_random_point(nav_map, 1, true)
	parent.next_nav_point = random_point
	parent.animation_player.play("Walk")
	parent.speed = parent.WALK_SPEED
	
func update(delta: float) -> void:
	pass
