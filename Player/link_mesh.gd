extends MeshInstance3D


var target: Node3D


func _physics_process(delta: float) -> void:
	if not target:
		return
	if target.global_position.normalized().is_equal_approx(Vector3.UP):
		return
	look_at(target.global_position)
	force_update_transform()
	rotation.x += 0.5*PI
