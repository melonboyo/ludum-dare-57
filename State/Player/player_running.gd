extends PlayerGroundedState
class_name PlayerRunning


var previous


func update(delta):
	super(delta)
	
	if absf(player.move_input) < 0.05 and absf(player.get_real_velocity().x) < 0.1 * player.speed:
		transition.emit(self, "Idle")
		return


func physics_update(delta):
	super(delta)
	
	if player.current_state == Constants.PlayerState.THROWING:
		return
	
	var desired_velocity = Vector3.RIGHT * player.move_input * player.speed
	player.move_velocity = player.move_velocity.move_toward(desired_velocity, delta * player.ground_acceleration)
	
	if absf(player.get_real_velocity().x) > 1.0:
		player.play_animation("run", false)
		player.set_playback_speed(1.3 * absf(player.move_velocity.x) / player.walk_speed)
	else:
		player.play_animation("idle")


func enter():
	player.play_animation("run", false)
	player.set_playback_speed(absf(player.move_velocity.x) / player.walk_speed)
