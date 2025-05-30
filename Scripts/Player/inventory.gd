extends Node

@onready var ui: Control = $"../UI"

var items = {"coins":0}

func _ready() -> void:
	pass
	
func get_item(item: String) -> void:
	print("got: " + item)
	match item:
		"coins":
			get_money(10)
			
			
			
func get_money(amount: int) -> void:
	items["coins"] = items["coins"] + amount
	ui.update_money(items["coins"])
