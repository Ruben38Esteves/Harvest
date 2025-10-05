extends interactible

var cost: int = 0
@onready var timer = $Timer
var common_items = []
var uncommon_items = []

func _ready() -> void:
	common_items.push_back(preload("res://Items/Broccoli/Broccoli.tscn"))
	common_items.push_back(preload("res://Items/SweetSoda/SweetSoda.tscn"))
	common_items.push_back(preload("res://Items/SuspiciousMushroom/SuspiciousMushroom.tscn"))
	uncommon_items.push_back(preload("res://Items/FluffyCotton/FluffyCotton.tscn"))

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
	var rarity = randf()
	var choice = null
	if rarity < 0.3:
		choice = uncommon_items[randi() % uncommon_items.size()]
	else:
		choice = common_items[randi() % common_items.size()]
	return choice
