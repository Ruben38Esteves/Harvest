extends Control

@onready var crossair: ColorRect = $crossair
@onready var crossair2: ColorRect = $crossair2
@onready var info = $Info
@onready var kill_amount_display: Label = $Hud/timer/Kills/KillAmount
@onready var world_timer: Timer = $WorldTimer
@onready var time_label: Label = $Hud/timer/Time
@onready var money_value: Label = $Hud/Money/MoneyValue
@onready var primary_ammo_label: Label = $Hud/Ammo/Primary
@onready var secondary_ammo_label: Label = $Hud/Ammo/Secondary

var time = 0
var kill_amount: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_corsair_location()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_info_visibility_changed():
	await get_tree().create_timer(2.0).timeout
	info.visible = false

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
	var minutes = str(time / 60)
	var seconds = str(time % 60)
	time_label.text= minutes + ":" + seconds
	
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
