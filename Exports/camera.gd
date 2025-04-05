extends Node3D


@export_node_path("Node3D") var focus_path: NodePath
@onready var focus: Node3D = get_node(focus_path)


func _physics_process(delta):
	global_position = global_position.lerp(focus.global_position * Vector3(1,0,1) + Vector3.UP * 2.0, delta * 5.0)
