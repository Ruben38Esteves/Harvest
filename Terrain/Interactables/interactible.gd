class_name interactible

extends StaticBody3D

const OUTLINE_SHADER: Material = preload("res://Terrain/Interactables/Outline/outline.tres")
@onready var body: MeshInstance3D = $Body

@export var type: String = ""

func _ready():
	pass

func set_targetted():
	body.material_overlay = OUTLINE_SHADER
	print("target")
	
func set_untargetted():
	body.material_overlay = null
	print("no target")
	
func interact() -> bool:
	return false
