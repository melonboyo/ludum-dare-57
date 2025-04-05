extends PlayerGroundedState
class_name PlayerSliding


var enter_direction: Vector3


func enter():
	enter_direction = player.input_direction3.normalized()


func update(delta):
	super(delta)
	
	if player.input_direction3.length() < 0.01 and player.move_velocity.length() < 0.2*player.speed:
		transition.emit(self, "Idle")
		return
	
	if (
		not player.is_running or
		player.input_direction3.length() < 0.8 or
		player.move_velocity.dot(player.input_direction3) > 0.75*player.speed or 
		abs(enter_direction.angle_to(player.input_direction3.normalized())) > 0.4*PI
	):
		transition.emit(self, "Running")


func physics_update(delta):
	super(delta)
	
	var desired_velocity = player.input_direction3 * player.run_speed
	player.move_velocity = player.move_velocity.move_toward(desired_velocity, delta * player.slide_acceleration)
