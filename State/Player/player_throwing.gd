extends PlayerState
class_name PlayerThrowing


@export var cooldown_timer: Timer


func exit():
	cooldown_timer.start()
	player.can_throw_rope = false


func enter():
	var throw_direction := Vector3.RIGHT
	var power := 9.0
	if not player.is_on_floor():
		power = 9.0 + 4.0 * player.input_direction.length()
		throw_direction = Vector3.RIGHT * (player.move_input) + Vector3.UP * (player.vertical_input + 0.3)
		if player.last_strong_move_input > 0.0:
			throw_direction += Vector3.RIGHT * 0.4
		else:
			throw_direction -= Vector3.RIGHT * 0.4
	else:
		if absf(player.move_input) > 0.4:
			power = 11.0 + 5.0 * absf(player.move_input)
			if player.move_input > 0.4:
				throw_direction = Vector3.RIGHT * 0.65 + Vector3.UP * 0.35
			elif player.move_input < 0.4:
				throw_direction = Vector3.LEFT * 0.65 + Vector3.UP * 0.35
		else:
			if player.vertical_input > 0.5:
				power = 11.5 + 4.5 * player.vertical_input
				throw_direction = Vector3.UP
				throw_direction += Vector3.RIGHT * 0.1 if player.last_strong_move_input > 0.0 else Vector3.LEFT * 0.1
			elif player.vertical_input < -0.5:
				power = 9.0
				throw_direction = Vector3.RIGHT if player.last_strong_move_input > 0.0 else Vector3.LEFT
				throw_direction += Vector3.DOWN * 0.1
			else:
				power = 9.0
				throw_direction = Vector3.RIGHT * 0.5 + Vector3.UP * 0.5 if player.last_strong_move_input > 0.0 else Vector3.LEFT * 0.5 + Vector3.UP * 0.5
	throw_direction = throw_direction.normalized()
	
	player.play_animation("throw")
	player.velocity = Vector3.ZERO
	player.move_velocity *= 0.08
	player.vertical_velocity = Vector3.ZERO
	player.move_and_slide()
	
	await get_tree().create_timer(0.33).timeout
	
	player.throw_rope(throw_direction, power)
	var return_state = "InAir" if not player.is_on_floor() else "Idle"
	
	transition.emit(self, return_state)


func physics_update(delta):
	pass
	#player.vertical_velocity += Vector3.DOWN * player.gravity * delta
	#player.vertical_velocity.y = maxf(player.vertical_velocity.y, -player.max_fall_speed)
