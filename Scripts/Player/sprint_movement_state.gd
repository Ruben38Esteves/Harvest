class_name SprintMovementState

extends State

@onready var player: CharacterBody3D = $"../.."
@onready var state_machine: StateMachine = $".."

# Called when the node enters the scene tree for the first time.
func enter(last_state: String) -> void:
	player.speed = player.SPRINT_SPEED
	player.TARGET_FOV = player.SPRINT_FOV
	
func update(delta) -> void:
	# jump
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("JumpMovementState")
	# walk
	if Input.is_action_just_released("sprint") or Input.is_action_pressed("back") or Input.is_action_pressed("crouch") or !player.is_on_floor():
		state_machine.change_state("WalkingMovementState")
	# crouch
	if Input.is_action_just_pressed("crouch"):
		state_machine.change_state("SlideMovementState")
	

func exit() -> void:
	player.TARGET_FOV = player.BASE_FOV
	#print("leaving sprint")
