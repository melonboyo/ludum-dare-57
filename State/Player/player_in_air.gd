extends PlayerState
class_name PlayerInAir


@export var on_ledge_state: PlayerState
@export var early_jump_buffer: Timer

@export_subgroup("Ledge Detection")
@export var ledge_top_ray: RayCast3D
@export var ledge_bottom_ray: RayCast3D
@export var ledge_check_ray: RayCast3D

var allow_ledge_grab := true


func update(_delta):
	if Input.is_action_just_pressed("jump"):
		if not early_jump_buffer.is_stopped():
			early_jump_buffer.stop()
		early_jump_buffer.start()


func physics_update(delta):
	if player.is_on_floor() and player.move_velocity.length() > 0.1:
		transition.emit(self, "Running")
		return
	
	if player.is_on_floor():
		transition.emit(self, "Idle")
		return
	
	if allow_ledge_grab and is_at_ledge():
		allow_ledge_grab = false
		transition.emit(self, "OnLedge")
		return
	
	var desired_velocity = Vector3.RIGHT * player.move_input * player.speed
	player.move_velocity = player.move_velocity.move_toward(desired_velocity, delta * player.air_acceleration)
	player.gravity_velocity += Vector3.DOWN * player.gravity * delta
	player.gravity_velocity.y = maxf(player.gravity_velocity.y, -player.max_fall_speed)
	
	rotate_to_direction_instant(player.last_strong_move_input)


func is_at_ledge() -> bool:
	if ledge_top_ray.is_colliding():
		return false
	if not ledge_bottom_ray.is_colliding():
		return false
	var bottom_angle := ledge_bottom_ray.get_collision_normal().angle_to(Vector3.UP)
	if bottom_angle < player.floor_max_angle:
		return false
	if not ledge_check_ray.is_colliding():
		return false
	var check_angle := ledge_check_ray.get_collision_normal().angle_to(Vector3.UP)
	if absf(check_angle - bottom_angle) < 0.3*PI:
		return false
	if ledge_check_ray.get_collision_normal().angle_to(Vector3.UP) >= player.floor_max_angle:
		return false
	return true


func freeze():
	transition.emit(self, "Frozen")


func _on_ledge_timer_timeout():
	allow_ledge_grab = true
