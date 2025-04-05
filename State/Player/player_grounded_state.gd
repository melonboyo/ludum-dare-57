extends PlayerState
class_name PlayerGroundedState


@export var early_jump_buffer: Timer


func update(_delta):
	if Input.is_action_pressed("jump") and player.hold_to_jump:
		transition.emit(self, "ReadyJump")
		return


func physics_update(delta):
	player.gravity_velocity = Vector3.DOWN * 0.5
	
	if (Input.is_action_just_pressed("jump") or not early_jump_buffer.is_stopped()) and not player.hold_to_jump:
		early_jump_buffer.stop()
		player.jump()
		transition.emit(self, "InAir")
		return
	
	if not player.is_on_floor():
		transition.emit(self, "InAir")
		return
	
	rotate_to_direction_instant(player.last_strong_move_input)
