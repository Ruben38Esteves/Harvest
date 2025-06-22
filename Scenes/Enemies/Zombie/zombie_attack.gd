extends Hitbox

var knockback: float = 300.0

func _on_body_entered(body):
	if body is Player:
		if one_hit and player_hit:
			return
		var direction: Vector3 = parent.global_position - body.global_position
		print(direction)
		var impulse: Vector3 = direction.normalized() * knockback
		print(impulse)
		#impulse.y += 2.0
		body.hit(damage,impulse)
