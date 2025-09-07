extends Hitbox

var knockback: float = 10.0

func _on_body_entered(body):
	if body is not Player:
		return
	if one_hit and player_hit:
		return
	var direction: Vector3 = body.global_position - parent.global_position
	var impulse: Vector3 = direction.normalized() * knockback
	impulse.y = 0.0
	body.hit(damage,impulse)
