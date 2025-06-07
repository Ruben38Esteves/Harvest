extends interactible

var cost: int = 0
@onready var timer = $Timer
var common_items = []

func _ready() -> void:
	common_items.push_back(preload("res://Scenes/Interactables/Items/Broccoli.tscn"))
	common_items.push_back(preload("res://Scenes/Interactables/Items/SuspiciousMushroom.tscn"))
	common_items.push_back(preload("res://Scenes/Interactables/Items/SweetSoda.tscn"))
	

func interact() -> bool:
	var player_money = global.player.inventory.items["coins"]
	if player_money >= cost:
		player_money = player_money - cost
		global.player.inventory.spend_money(cost)
		timer.start()
		return true
	return false


func _on_timer_timeout():
	var random_item = get_random_item()
	var instance = random_item.instantiate()
	instance.global_position = position
	get_parent().add_child(instance)
	instance.global_position.y = instance.global_position.y +1
	instance.get_child(0).apply_impulse(Vector3(0,1,0))
	queue_free()

func get_random_item():
	randomize()
	var choice = common_items[randi() % common_items.size()]
	return choice
