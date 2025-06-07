class_name inventory

extends Node

@onready var ui: Control = $"../UI"

var items = {
	"coins": 0,
	"broccoli": 0,
	"suspicious_mushroom": 0,
	"sweet_soda": 0,
	"fluffy_cotton": 0,
}

var cotton_active = false

func _ready() -> void:
	pass
	
func get_item(item: String) -> void:
	
	match item:
		"coins":
			items["coins"] = items["coins"] + 10 # hardcoded to always provide 10 coins
			ui.update_money(items["coins"])
		_:
			items[item] = items[item] + 1
			ui.update_item_display(item)
	print("got: " + item , " and now have: ", items[item])
	
func spend_money(amount: int) -> void:
	items["coins"] = items["coins"] - amount
	ui.update_money(items["coins"])
	
func has_item(item_name: String) -> bool:
	return items[item_name] > 0

func activate_cotton() -> void:
	if has_item("fluffy_cotton"):
		cotton_active = true

func deactivate_cotton() -> void:
	cotton_active = false
