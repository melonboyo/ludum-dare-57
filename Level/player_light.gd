@tool
extends OmniLight3D


@export var player: Player:
	set(value):
		player = value
		if not Engine.is_editor_hint():
			return
		if not player:
			return
		global_position = player.global_position + Vector3.UP * y_offset + Vector3.BACK * z_offset
@export var y_offset := 0.0:
	set(value):
		y_offset = value
		if not Engine.is_editor_hint():
			return
		if not player:
			return
		global_position = player.global_position + Vector3.UP * y_offset + Vector3.BACK * z_offset
@export var z_offset := 0.0:
	set(value):
		z_offset = value
		if not Engine.is_editor_hint():
			return
		if not player:
			return
		global_position = player.global_position + Vector3.UP * y_offset + Vector3.BACK * z_offset


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	global_position = player.global_position + Vector3.UP * y_offset + Vector3.BACK * z_offset
