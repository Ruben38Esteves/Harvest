class_name JumpMovementState

extends State

@onready var player: CharacterBody3D = $"../.."
@onready var state_machine: StateMachine = $".."

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	player.velocity.y = player.JUMP_VELOCITY

func update(delta) -> void:
	state_machine.change_state("FallingMovementState")

func exit() -> void:
	print("leaving jump")
