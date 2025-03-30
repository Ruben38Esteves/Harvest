class_name WalkingMovementState

extends State

@onready var player: CharacterBody3D = $"../.."
@onready var state_machine: StateMachine = $".."

func enter() -> void:
	player.speed = player.WALK_SPEED

func update(delta):
	if not player.is_on_floor():
		state_machine.change_state("FallingMovementState")
	if player.velocity.length() <= 0.1:
		state_machine.change_state("IdleMovementState")
	if Input.is_action_pressed("sprint") and !Input.is_action_pressed("back") and !Input.is_action_pressed("crouch") and global.player.is_on_floor():
		state_machine.change_state("SprintMovementState")
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("JumpMovementState")

func exit() -> void:
	print("leaving walking")
