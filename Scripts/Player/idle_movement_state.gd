class_name IdleMovementState

extends State

@onready var player: CharacterBody3D = $"../.."
@onready var state_machine: StateMachine = $".."

func update(delta):
	if not player.is_on_floor():
		state_machine.change_state("FallingMovementState")
		
	if player.velocity.length() > 0.0 and player.is_on_floor():
		state_machine.change_state("WalkingMovementState")
		
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("JumpMovementState")
		
	if Input.is_action_just_pressed("crouch"):
		pass
		

func exit() -> void:
	print("leaving idle")
