extends MeshInstance3D


var target: Node3D


func _physics_process(delta: float) -> void:
	if not target:
		return
	look_at(target.global_position)
	rotation.x += 0.5*PI
