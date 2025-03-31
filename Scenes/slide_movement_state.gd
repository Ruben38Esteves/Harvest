class_name SlideMovementState

extends State

@onready var player: CharacterBody3D = $"../.."
@onready var state_machine: StateMachine = $".."

func enter() -> void:
	player.crouch()
	player.sliding = true
	player.slide_speed = 12.5
	player.TARGET_FOV = player.SLIDE_FOV
	
func update(delta) -> void:
	if Input.is_action_just_released("crouch"):
		state_machine.change_state("IdleMovementState")
	#player.speed = lerp(player.speed, player.CROUCH_SPEED, 0.01 * delta)
	if player.velocity.length() <= player.CROUCH_SPEED:
		state_machine.change_state("CrouchMovementState")

func exit() -> void:
	player.TARGET_FOV = player.BASE_FOV
	player.uncrouch()
	player.sliding = false
