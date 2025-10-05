class_name EnemyHealthBar

extends Sprite3D

@onready var progress_bar = $SubViewport/VBoxContainer/ProgressBar
@onready var poison_indicator = $SubViewport/VBoxContainer/HBoxContainer/PoisonIndicator

var status_indicators = {}

func _ready():
	status_indicators["poison"] = poison_indicator

func show_status(status: String) -> void:
	if status_indicators.has(status):
		status_indicators[status].visible = true
	else:
		print("does not have: ", status)
	
func hide_status(status: String) -> void:
	if status_indicators.has(status):
		status_indicators[status].visible = false
	else:
		print("does not have: ", status)


func set_max_health(max_health: float) -> void:
	progress_bar.max_value = max_health

func set_health(health: float) -> void:
	progress_bar.value = health
