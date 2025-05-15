class_name FallingMovementState

extends State

@onready var player: CharacterBody3D = $"../.."
@onready var state_machine: StateMachine = $".."

# Called when the node enters the scene tree for the first time.
func enter(last_state: String) -> void:
	pass
	
func update(delta) -> void:
	if global.player.is_on_floor():
		if Input.is_action_pressed("jump"):
			state_machine.change_state("JumpMovementState")
		else:
			state_machine.change_state("IdleMovementState")

#func exit() -> void:
	#print("leaving falling")
