@tool
extends Node3D
class_name Level


@export var current_checkpoint := 2:
	set(value):
		if not Engine.is_editor_hint():
			return
		if not $CheckPoints.get_node(str(value)):
			return
		current_checkpoint = value
		$Player.global_position = $CheckPoints.get_node(str(value)).global_position
		$Focus.global_position = $CheckPoints.get_node(str(value)).global_position
		$PlayerLight.global_position = $CheckPoints.get_node(str(value)).global_position
		$CameraPivot.global_position = $CheckPoints.get_node(str(value)).global_position + Vector3.UP * 7.0


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	Loading.loading_finished.connect(on_loading_finished)


func on_loading_finished():
	if Engine.is_editor_hint():
		return
	%Camera3D.current = true
	$Player.disable_input = false


func _on_awaken_area_body_entered(body: Node3D) -> void:
	if Engine.is_editor_hint():
		return
	%AwakenArea.queue_free()
	%TransitionAnimationPlayer.play("fade_away")
	AudioServer.set_bus_effect_enabled(1, 0, true)
	AudioServer.set_bus_effect_enabled(2, 0, true)


func _on_dark_fade_away_animation_finished(anim_name: StringName) -> void:
	if Engine.is_editor_hint():
		return
	if anim_name == StringName("fade_away"):
		pass
