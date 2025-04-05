extends PlayerState
class_name PlayerReadyJump


func update(delta):
	if not player.is_on_floor():
		transition.emit(self, "InAir")
		return


func physics_update(delta):
	if not Input.is_action_pressed("jump"):
		player.jump()
		transition.emit(self, "InAir")
		return
	
	var desired_velocity = player.input_direction3 * player.run_speed * 0.1
	player.move_velocity = player.move_velocity.move_toward(desired_velocity, delta * player.ground_acceleration)
	player.vertical_velocity = Vector3.DOWN * 0.5
	rotate_to_direction(player.last_strong_direction, delta)
