extends Node3D


signal loading_finished


func _on_timer_timeout() -> void:
	loading_finished.emit()
	$Camera3D.current = false
	await get_tree().create_timer(0.05).timeout
	queue_free()
