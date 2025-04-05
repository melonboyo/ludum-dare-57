extends PlayerGroundedState
class_name PlayerIdle


func update(delta):
	super(delta)
	
	if absf(player.move_input) > 0.05:
		#if player.is_running and (player.input_direction3.angle_to(player.global_basis.z.normalized()) > 0.4*PI):
			#transition.emit(self, "Sliding")
			#return
		transition.emit(self, "Running")
		return


func physics_update(delta):
	super(delta)
	
	player.move_velocity = player.move_velocity.move_toward(Vector3.ZERO, delta * player.ground_acceleration)
	rotate_to_direction_instant(player.last_strong_move_input)
