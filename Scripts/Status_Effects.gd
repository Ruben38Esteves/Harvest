extends Node

@onready var owner_object
@onready var timer = $Timer

var is_poisoned = false
var poison_duration = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_poisoned():
	if timer.is_stopped():
		timer.start()
	is_poisoned = true
	poison_duration = 5

func _on_timer_timeout():
	if is_poisoned:
		get_parent().attacked(5)
		poison_duration -= 1
		if poison_duration <= 0:
			is_poisoned = false
