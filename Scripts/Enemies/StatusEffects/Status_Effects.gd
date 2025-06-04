class_name status_effects

extends Node

@onready var proc_timer: Timer = $ProcTimer
@onready var duration_timer: Timer = $DurationTimer

var active = false
@export var type: String = ""
@export var damage: float = 0
@export var duration: float = 4
@export var frequency: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_duration(duration)
	set_proc_frequency(frequency)
	proc_timer.timeout.connect(proc)
	duration_timer.timeout.connect(deactivate)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_duration(duration: float) -> void:
	duration_timer.wait_time = duration
	
func set_proc_frequency(frequency: float) -> void:
	proc_timer.wait_time = 1.0 / frequency

func activate() -> void:
	if active:
		return
	active = true
	proc_timer.start()
	duration_timer.start()
	
func deactivate() -> void:
	if not active:
		return
	active = false
	proc_timer.stop()
	
func proc() -> void:
	print("procced")
	get_parent().hit(damage)
