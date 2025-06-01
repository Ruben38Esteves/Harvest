class_name ItemUI

extends PanelContainer

@onready var item_icon: TextureRect = $ItemIcon
@onready var amount_label: Label = $Amount
var amount = 1

func set_icon(texture_path: String) -> void:
	item_icon.texture = load(texture_path)
	
func set_amount(new_amount: int) -> void:
	amount = new_amount
	amount_label.text = str(amount)
	
func increment_amount() -> void:
	amount += 1
	amount_label.text = str(amount)
	
