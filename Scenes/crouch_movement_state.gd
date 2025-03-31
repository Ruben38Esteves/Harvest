class_name CrouchMovementState

extends State

@onready var player: CharacterBody3D = $"../.."
@onready var state_machine: StateMachine = $".."
var leaving_crouch: bool

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	leaving_crouch = false
	player.crouch()
	player.speed = player.CROUCH_SPEED
	
func update(delta) -> void:
	if Input.is_action_just_released("crouch"):
		leaving_crouch = true
	
	if leaving_crouch:
		if player.can_stand():
			state_machine.change_state("IdleMovementState")
			
	if Input.is_action_just_pressed("crouch"):
		leaving_crouch = false

func exit() -> void:
	player.uncrouch()
	#print("leaving falling")
