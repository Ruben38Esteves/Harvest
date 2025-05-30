extends interactible

var cost: int = 0
@onready var timer = $Timer

func interact() -> bool:
	var player_money = global.player.inventory.items["coins"]
	if player_money >= cost:
		player_money = player_money - cost
		global.player.inventory.spend_money(cost)
		timer.start()
		return true
	return false


func _on_timer_timeout():
	queue_free()
