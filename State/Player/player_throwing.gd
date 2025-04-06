extends PlayerState
class_name PlayerThrowing


@export var cooldown_timer: Timer


func enter():
	player.last_strong_move_input
	player.play_animation("throw")
	player.velocity = Vector3.ZERO
	player.move_velocity = Vector3.ZERO
	player.vertical_velocity = Vector3.ZERO
	player.move_and_slide()
	
	await get_tree().create_timer(0.28).timeout
	
	player.throw_rope()
	var return_state = "InAir" if not player.is_on_floor() else "Idle"
	player.can_throw_rope = false
	cooldown_timer.start()
	
	transition.emit(self, return_state)
