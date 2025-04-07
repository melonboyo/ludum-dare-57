extends Node3D


@export var player: Player
@export var camera: Camera
@export var lookdown_timer: Timer
@export var lookup_timer: Timer
@export_range(-15, 0) var lookdown_distance: float = -5.0
@export_range(-60, 60) var lookdown_angle: float = 5.0
@export_range(0, 15) var lookup_distance: float = 5.0
@export_range(-60, 60) var lookup_angle: float = -5.0
var y: float = 0.0
var lookdown := false
var lookup := false


func _process(delta: float) -> void:
	if not GameState.player_state == Constants.PlayerState.IDLE:
		stop()
		return
	if camera.override_angle:
		return
	if (
		Input.is_action_pressed("down") and 
		not Input.is_action_pressed("up")
	):
		if lookdown_timer.is_stopped() and not lookdown:
			lookdown_timer.start()
	elif Input.is_action_pressed("up") and not Input.is_action_pressed("down"):
		if lookup_timer.is_stopped() and not lookup:
			lookup_timer.start()
	else:
		stop()


func stop():
	if not lookdown_timer.is_stopped():
		lookdown_timer.stop()
	lookdown = false
	if not lookup_timer.is_stopped():
		lookup_timer.stop()
	lookup = false


func _physics_process(delta: float) -> void:
	var y_offset := 0.0 if not lookdown else lookdown_distance
	y_offset = y_offset if not lookup else lookup_distance
	var offset_speed := 8.0 if (lookdown or lookup) else 3.5
	y = lerpf(y, y_offset, delta * offset_speed)
	global_position = player.global_position + Vector3.UP * y
	
	var angle := deg_to_rad(camera.default_angle) if not lookdown else deg_to_rad(camera.min_angle)
	angle = angle if not lookup else deg_to_rad(camera.max_angle)
	var angle_speed := 1.0*PI if (lookdown or lookup) else 0.8*PI
	if camera.override_angle:
		angle = camera.overridden_angle.x
	camera.rotation.x = lerp_angle(camera.rotation.x, angle, delta * angle_speed)
	if camera.override_angle:
		camera.rotation.y = lerp_angle(camera.rotation.y, camera.overridden_angle.y, delta * angle_speed)
	else:
		camera.rotation.y = lerp_angle(camera.rotation.y, 0, delta * angle_speed)


func _on_lookdown_hold_timer_timeout() -> void:
	lookdown = true


func _on_lookup_hold_timer_timeout() -> void:
	lookup = true
