extends PlayerState
class_name PlayerStunned


@export var stun_timer: Timer
@export var stun_player: AudioStreamPlayer


func enter():
	stun_timer.start()
	player.disable_input = true
	player.move_velocity = Vector3.ZERO
	#player.disable_velocities = true
	player.play_animation("stunned")
	stun_player.play()


func exit():
	player.disable_input = false
	#player.disable_velocities = false


func _on_stun_timer_timeout() -> void:
	transition.emit(self, "Idle")
