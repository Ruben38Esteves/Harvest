class_name ui

extends Control

@onready var crossair: ColorRect = $crossair
@onready var crossair2: ColorRect = $crossair2
@onready var kill_amount_display: Label = $Hud/timer/Kills/KillAmount
@onready var world_timer: Timer = $WorldTimer
@onready var time_label: Label = $Hud/timer/Time
@onready var money_value: Label = $Hud/timer/Money/MoneyValue
@onready var primary_ammo_label: Label = $Hud/BottomRight/Primary
@onready var secondary_ammo_label: Label = $Hud/BottomRight/Secondary
@onready var item_inventory_container: HBoxContainer = $Hud/ItemInventoryContainer
@onready var info = $Hud/Info

#buffs
var buff_indicators = {}

const ITEM_UI = preload("res://Scenes/UI/item_ui.tscn")
var item_dict = {}
var item_textures = {
	"broccoli": "res://Textures/broccoli_sprite.png",
	"suspicious_mushroom": "res://Textures/mushroom_sprite.png",
	"sweet_soda": "res://Textures/soda_sprite.png",
	"fluffy_cotton": "res://Textures/fluffy_cotton_sprite.png",
}

var time = 0
var kill_amount: int = 0

var seconds_str = ""
var minutes_str = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	set_corsair_location()
	buff_indicators["eletricity"] = $Hud/BottomLeft/BuffsContainer/EletricityIndicator


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_info(text: String) -> void:
	info.text = text
	info.visible = true
	await get_tree().create_timer(2.0).timeout
	info.visible = false

#func _on_info_visibility_changed():
	#await get_tree().create_timer(2.0).timeout
	#info.visible = false

func set_corsair_location():
	crossair.position.x = (get_viewport().size.x / 2) - crossair.size.x / 2
	crossair.position.y = (get_viewport().size.y / 2) - crossair.size.y / 2
	crossair2.position.x = (get_viewport().size.x / 2) - crossair2.size.x / 2
	crossair2.position.y = (get_viewport().size.y / 2) - crossair2.size.y / 2
	
func enemy_hit() -> void:
	crossair2.visible = true
	await get_tree().create_timer(0.1).timeout
	crossair2.visible = false
	
func enemy_killed() -> void:
	kill_amount += 1
	kill_amount_display.text = str(kill_amount)


func _on_world_timer_timeout() -> void:
	time += 1
	var minutes: int = time / 60
	var seconds: int = time % 60
	if seconds < 10:
		seconds_str = "0" + str(seconds)
	else:
		seconds_str = str(seconds)
	if minutes < 10:
		minutes_str = "0" + str(minutes)
	else:
		minutes_str = str(minutes)
		
	time_label.text= minutes_str + ":" + seconds_str
	
func update_money(amount: int) -> void:
	money_value.text = str(amount)
	
func update_ammo_display(type: String, magazine: int, total: int) -> void:
	match type:
		"primary":
			primary_ammo_label.text = str(magazine) + "/" + str(total)
		"secondary":
			secondary_ammo_label.text = str(magazine) + "/" + str(total)
		_:
			print(type + " is not a weapon type")
			
func update_item_display(item: String) -> void:
	print(item)
	if item_dict.has(item):
		item_dict[item].increment_amount()
	else:
		var new_item = ITEM_UI.instantiate()
		item_dict[item] = new_item
		item_inventory_container.add_child(new_item)
		new_item.set_icon(item_textures[item])
		
func display_buff(buff_name: String) -> void:
	if not buff_indicators.has(buff_name):
		return
	buff_indicators[buff_name].visible = true
	
func hide_buff(buff_name: String) -> void:
	if not buff_indicators.has(buff_name):
		return
	buff_indicators[buff_name].visible = false
