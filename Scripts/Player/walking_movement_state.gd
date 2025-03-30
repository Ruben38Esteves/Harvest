class_name WalkingMovementState

extends State

@onready var player: CharacterBody3D = $"../.."
@onready var state_machine: StateMachine = $".."

func enter() -> void:
	player.speed = player.WALK_SPEED

func update(delta):
	# falling
	if not player.is_on_floor():
		state_machine.change_state("FallingMovementState")
	# stop moving
	if player.velocity.length() <= 0.1:
		state_machine.change_state("IdleMovementState")
	# sprint
	if Input.is_action_pressed("sprint") and !Input.is_action_pressed("back") and !Input.is_action_pressed("crouch") and global.player.is_on_floor():
		state_machine.change_state("SprintMovementState")
	# jump
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("JumpMovementState")
	# crouch
	if Input.is_action_just_pressed("crouch"):
		state_machine.change_state("CrouchMovementState")

func exit() -> void:
	print("leaving walking")
