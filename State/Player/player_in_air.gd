extends PlayerState
class_name PlayerInAir


@export var on_ledge_state: PlayerState
@export var early_jump_buffer: Timer
@export var land_player: AudioStreamPlayer
@export var fall_player: AudioStreamPlayer

@export_subgroup("Ledge Detection")
@export var ledge_top_ray: RayCast3D
@export var ledge_bottom_ray: RayCast3D
@export var ledge_check_ray: RayCast3D

var allow_ledge_grab := true


func enter():
	pass


func exit():
	fall_player.volume_db = -80.0


func update(delta):
	super(delta)
	
	if player.in_climb_area:
		if Input.is_action_just_pressed("up"):
			transition.emit(self, "Climbing")
			return
	
	if Input.is_action_just_pressed("jump"):
		if not early_jump_buffer.is_stopped():
			early_jump_buffer.stop()
		early_jump_buffer.start()
	
	if player.velocity.y > 0.0:
		player.play_animation("jumpup")
	else:
		player.play_animation("jumpdown")


func physics_update(delta):
	super(delta)
	
	if player.in_climb_area:
		if Input.is_action_just_pressed("up"):
			transition.emit(self, "Climbing")
			return
	
	if player.is_on_floor():
		print(player.prev_velocity.y)
		if player.prev_velocity.y < -35.0:
			transition.emit(self, "Stunned")
		elif player.move_velocity.length() > 0.1:
			transition.emit(self, "Running")
			land_player.play()
		else:
			transition.emit(self, "Idle")
			land_player.play()
		return
	
	if allow_ledge_grab and is_at_ledge():
		allow_ledge_grab = false
		transition.emit(self, "OnLedge")
		return
	
	if Input.is_action_just_pressed("throw") and player.can_throw_rope:
		transition.emit(self, "Throwing")
		return
	
	var desired_velocity = Vector3.RIGHT * player.move_input * player.speed
	player.move_velocity = player.move_velocity.move_toward(desired_velocity, delta * player.air_acceleration)
	player.vertical_velocity += Vector3.DOWN * player.gravity * delta
	player.vertical_velocity.y = maxf(player.vertical_velocity.y, -player.max_fall_speed)
	
	fall_player.volume_db = remap(player.get_real_velocity().y, 0.0, -42.0, -80.0, -16.0)
	
	rotate_to_direction_instant(player.last_strong_move_input)


func is_at_ledge() -> bool:
	if ledge_top_ray.is_colliding():
		return false
	if not ledge_bottom_ray.is_colliding():
		return false
	var bottom_angle := ledge_bottom_ray.get_collision_normal().angle_to(Vector3.UP)
	if bottom_angle < player.floor_max_angle:
		return false
	var bottom_collision_point := ledge_bottom_ray.get_collision_point()
	ledge_check_ray.global_position = Vector3(bottom_collision_point.x, ledge_check_ray.global_position.y, 0.0)
	ledge_check_ray.global_position += Vector3.RIGHT * 0.15 * player.last_strong_move_input
	ledge_check_ray.force_raycast_update()
	if not ledge_check_ray.is_colliding():
		return false
	var check_angle := ledge_check_ray.get_collision_normal().angle_to(Vector3.UP)
	#print("b ", bottom_angle/PI)
	#print("c ", check_angle/PI)
	#print(absf(check_angle - bottom_angle)/PI)
	if absf(check_angle - bottom_angle) < 0.3*PI:
		return false
	if ledge_check_ray.get_collision_normal().angle_to(Vector3.UP) >= player.floor_max_angle:
		return false
	return true


func freeze():
	transition.emit(self, "Frozen")


func _on_ledge_timer_timeout():
	allow_ledge_grab = true
