extends PlayerState
class_name PlayerClimbing


const vertical_offset := 0.3


func enter():
	player.disable_velocities = true
	player.play_animation("climb")
	player.set_playback_speed(0.0)
	
	var direction := -(player.global_position - GameState.current_rope_path.global_position)
	direction = Vector3(direction.x, 0, 0).normalized()
	player.last_strong_move_input = direction.x
	player.flip_sprite(direction.x < 0.0)
	player.get_node("Sprite").position.x = vertical_offset if direction.x < 0.0 else -vertical_offset
	
	GameState.current_rope_path.force_update_transform()
	GameState.current_rope_path_follow.global_position = player.global_position
	GameState.current_rope_path_follow.force_update_transform()
	var offset = GameState.current_rope_path.get_curve().get_closest_offset(
		GameState.current_rope_path_follow.position
	)
	GameState.current_rope_path_follow.progress = offset
	GameState.current_rope_path.force_update_transform()
	GameState.current_rope_path_follow.force_update_transform()
	
	player.global_position = GameState.current_rope_path_follow.global_position
	var angle_to_vec := Vector3.LEFT if player.last_strong_move_input > 0.0 else Vector3.RIGHT
	player.rotation.z = -GameState.current_rope_path.get_curve(). \
		sample_baked_up_vector(offset, true).angle_to(angle_to_vec)
	player.force_update_transform()


func exit():
	player.disable_velocities = false
	player.rotation.z = 0.0
	player.get_node("Sprite").position.x = 0.0


func update(delta: float) -> void:
	player.play_animation("climb")


func physics_update(delta: float) -> void:
	if Input.is_action_pressed("down") or Input.is_action_pressed("up"):
		player.set_playback_speed(1.0)
	else:
		player.set_playback_speed(0.0)
	
	if Input.is_action_just_pressed("jump"):
		player.jump(true)
		transition.emit(self, "InAir")
		return
	
	if not player.rope_links_in_area.is_empty():
		for l: RigidBody3D in player.rope_links_in_area:
			l.add_constant_force(Vector3.RIGHT * player.move_input * 0.2)
			if absf(player.move_input) < 0.1:
				l.constant_force = Vector3.ZERO
	
	var move := 0.0
	if Input.is_action_pressed("down"):
		move = player.climb_speed * delta
	if Input.is_action_pressed("up"):
		move = -player.climb_speed * delta
	GameState.current_rope_path_follow.progress += move
	GameState.current_rope_path_follow.progress = clampf(
		GameState.current_rope_path_follow.progress, 
		0.0, GameState.current_rope_path.get_curve().get_baked_length()
	)
	GameState.current_rope_path_follow.force_update_transform()
	
	var angle_to_vec := Vector3.LEFT if player.last_strong_move_input < 0.0 else Vector3.RIGHT
	var mult := 1.0 if player.last_strong_move_input < 0.0 else -1.0
	mult = -1
	
	player.global_position = GameState.current_rope_path_follow.global_position
	player.rotation.z = PI + mult * GameState.current_rope_path.get_curve().sample_baked_up_vector(
		GameState.current_rope_path_follow.progress, true
		).signed_angle_to(angle_to_vec, Vector3.BACK)
