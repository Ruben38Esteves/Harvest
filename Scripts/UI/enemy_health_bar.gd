class_name EnemyHealthBar

extends Sprite3D

@onready var progress_bar = $SubViewport/VBoxContainer/ProgressBar

func set_max_health(max_health: float) -> void:
	progress_bar.max_value = max_health

func set_health(health: float) -> void:
	progress_bar.value = health
