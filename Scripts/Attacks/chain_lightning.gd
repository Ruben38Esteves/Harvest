extends Node3D
@onready var path_3d: Path3D = $Path3D


func create_lightning_path(start: Vector3, end: Vector3, segments: int = 10, offset: float = 0.5):
	var curve = Curve3D.new()
	for i in range(segments + 1):
		var t = float(i) / segments
		var pos = start.lerp(end, t)
		if i != 0 and i != segments:
			pos += Vector3(
				randf_range(-offset, offset),
				randf_range(-offset, offset),
				randf_range(-offset, offset)
			)
		curve.add_point(pos)
	path_3d.curve = curve
