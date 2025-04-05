extends Node3D


@export var player: Player
@export var lookdown_timer: Timer
@export_range(0, 15) var lookdown_distance: float = 5.0
var y: float = 0.0
var lookdown := false


func _process(delta: float) -> void:
	if Input.is_action_pressed("down"):
		if lookdown_timer.is_stopped() and not lookdown:
			lookdown_timer.start()
	else:
		if not lookdown_timer.is_stopped():
			lookdown_timer.stop()
		lookdown = false


func _physics_process(delta: float) -> void:
	var y_offset := 0.0 if not lookdown else lookdown_distance
	var offset_speed := 3.5 if not lookdown else 8.0
	y = lerpf(y, y_offset, delta * offset_speed)
	global_position = player.global_position + Vector3.DOWN * y


func _on_lookdown_hold_timer_timeout() -> void:
	lookdown = true
