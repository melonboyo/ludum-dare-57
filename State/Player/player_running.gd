extends PlayerGroundedState
class_name PlayerRunning


var previous


func update(delta):
	super(delta)
	
	#if (
		#absf(player.move_input) > 0.5 and
		#player.move_velocity.length() > 0.2*player.run_speed and
		#(
			#abs(player.input_direction3.angle_to(player.global_basis.z.normalized())) > 0.5*PI or 
			#abs(player.input_direction3.angle_to(player.move_velocity.normalized())) > 0.5*PI
		#) and
		#Input.is_action_pressed("run")
	#):
		#transition.emit(self, "Sliding")
		#return
	
	if absf(player.move_input) < 0.05 and player.move_velocity.length() < 0.2 * player.speed:
		transition.emit(self, "Idle")
		return


func physics_update(delta):
	super(delta)
	
	var desired_velocity = Vector3.RIGHT * player.move_input * player.speed
	player.move_velocity = player.move_velocity.move_toward(desired_velocity, delta * player.ground_acceleration)
