class_name SprintMovementState

extends State

@onready var player: CharacterBody3D = $"../.."
@onready var state_machine: StateMachine = $".."

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	player.speed = player.SPRINT_SPEED
	
func update(delta) -> void:
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("JumpMovementState")
	if Input.is_action_just_released("sprint") or Input.is_action_pressed("back") or Input.is_action_pressed("crouch") or !player.is_on_floor():
		state_machine.change_state("WalkingMovementState")
	

func exit() -> void:
	print("leaving sprint")
