extends PlayerState
class_name PlayerGroundedState


@export var early_jump_buffer: Timer
@export var rope_cooldown_timer: Timer


func update(delta):
	if player.in_climb_area:
		if Input.is_action_just_pressed("climb"):
			transition.emit(self, "Climbing")
			return
	
	if Input.is_action_just_pressed("throw") and player.can_throw_rope:
		transition.emit(self, "Throwing")
		return
	
	super(delta)


func physics_update(delta):
	if player.in_climb_area:
		if Input.is_action_just_pressed("climb"):
			transition.emit(self, "Climbing")
			return
	
	if Input.is_action_just_pressed("throw") and player.can_throw_rope:
		transition.emit(self, "Throwing")
		return
	
	player.vertical_velocity = Vector3.DOWN * 2.5
	
	rotate_to_direction_instant(player.last_strong_move_input)
	
	if (Input.is_action_just_pressed("jump") or not early_jump_buffer.is_stopped()):
		early_jump_buffer.stop()
		player.jump()
		transition.emit(self, "InAir")
		return
	
	if not player.is_on_floor():
		transition.emit(self, "InAir")
		return
