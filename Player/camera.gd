@tool
extends Node3D
class_name Camera

@export_node_path("Node3D") var focus_path: NodePath
@onready var focus: Node3D = get_node(focus_path)

@export var distance := 12.0:
	set(value):
		distance = value
		if not Engine.is_editor_hint():
			return
		$Camera3D.position.z = value
@export var y_offset := 0.0:
	set(value):
		y_offset = value
		if not Engine.is_editor_hint():
			return
		global_position = focus.global_position + Vector3.UP * y_offset
var changing_angle := false
@export_range(-60, 60) var default_angle := 0.0:
	set(value):
		default_angle = value
		if not Engine.is_editor_hint():
			return
		global_rotation_degrees.x = -default_angle
		if changing_angle:
			return
		changing_angle = true
		default_angle = clampf(default_angle, min_angle, max_angle)
		global_rotation_degrees.x = -default_angle
		changing_angle = false
@export_range(-60, 60) var max_angle := 0.0:
	set(value):
		max_angle = value
		if not Engine.is_editor_hint():
			return
		if changing_angle:
			return
		changing_angle = true
		min_angle = minf(min_angle, value)
		default_angle = minf(default_angle, value)
		changing_angle = false
@export_range(-60, 60) var min_angle := 0.0:
	set(value):
		min_angle = value
		if not Engine.is_editor_hint():
			return
		if changing_angle:
			return
		changing_angle = true
		max_angle = maxf(max_angle, value)
		default_angle = maxf(default_angle, value)
		changing_angle = false


func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	global_position = global_position.lerp(focus.global_position + Vector3.UP * y_offset, delta * 5.0)
