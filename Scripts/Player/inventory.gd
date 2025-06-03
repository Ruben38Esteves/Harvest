extends Node

@onready var ui: Control = $"../UI"

var items = {
	"coins": 0,
	"broccoli": 0,
	"suspicious_mushroom": 0,
	"sweet_soda": 0,
}

func _ready() -> void:
	pass
	
func get_item(item: String) -> void:
	
	match item:
		"coins":
			items["coins"] = items["coins"] + 10 # hardcoded to always provide 10 coins
			ui.update_money(items["coins"])
		"suspicious_mushroom":
			items["suspicious_mushroom"] = items["suspicious_mushroom"] + 1
			ui.update_item_display("suspicious_mushroom")
			global.player.update_max_health()
		_:
			items[item] = items[item] + 1
			ui.update_item_display(item)
	print("got: " + item , " and now have: ", items[item])
	
func spend_money(amount: int) -> void:
	items["coins"] = items["coins"] - amount
	ui.update_money(items["coins"])
