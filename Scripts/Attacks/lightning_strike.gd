extends Sprite3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("strike")

func despawn() -> void:
	pass
	#queue_free()
