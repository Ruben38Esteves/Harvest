class_name status_effects

extends Node

@onready var enemy_health_bar = $"../EnemyHealthBar"

@onready var timer = $Timer
# statuses
@onready var poison = $Poison
var statuses = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	statuses["poison"] = poison
	timer.timeout.connect(proc)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func apply_status(status_name: String) -> void:
	if statuses.has(status_name):
		if statuses[status_name].active == false:
			enemy_health_bar.show_status(status_name)
		statuses[status_name].activate()

func proc() -> void:
	var damage: float = 0
	for status_name in statuses:
		if statuses[status_name].active == true:
			damage += statuses[status_name].proc()
	if damage != 0:
		get_parent().hit(damage)
		
func status_ended(status_name: String) -> void:
	enemy_health_bar.hide_status(status_name)
