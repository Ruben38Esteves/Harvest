class_name status_effect

extends Node

@export var type: String = ""
@export var damage: float = 0
@export var duration: float = 4
var remaining_duration: float = 4

var active = false

func proc() -> float:
	remaining_duration -= 1
	if remaining_duration <= 0:
		deactivate()
	return damage

func activate() -> void:
	remaining_duration = duration
	active = true
	
func deactivate() -> void:
	if not active:
		return
	active = false
