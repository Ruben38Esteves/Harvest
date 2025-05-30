extends Node3D
@onready var axe_animation_player = $AnimationPlayer
@onready var axe_hitbox = $axe/Area3D/axe_hitbox
var damage = 70

var enemies_hit = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func shoot():
	if !axe_animation_player.is_playing():
		axe_animation_player.play("attack")


func _on_area_3d_area_entered(area):
	if area.is_in_group("enemy"):
		if enemies_hit.has(area.parent):
			return
		axe_animation_player.pause()
		var hit_point = axe_hitbox.global_position
		var enemy_hit = area.melee_hit(damage, hit_point)
		enemies_hit[enemy_hit] = true
		await get_tree().create_timer(0.05).timeout
		axe_animation_player.play()
		
func clear_enemies_hit() -> void:
	enemies_hit.clear()
