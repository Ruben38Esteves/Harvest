extends Node

@onready var ui: Control = $"../UI"

var items = {
	"coins":0,
	"broccoli":0,
	"suspicious_mushroom":0
}

func _ready() -> void:
	pass
	
func get_item(item: String) -> void:
	if item == "coins":
		items["coins"] = items["coins"] + 10 # hardcoded to always provide 10 coins
		ui.update_money(items["coins"])
	else:
		items[item] = items[item] + 1
		ui.update_item_display(item)
	print("got: " + item , " and now have: ", items[item])
	
func spend_money(amount: int) -> void:
	items["coins"] = items["coins"] - amount
	ui.update_money(items["coins"])
