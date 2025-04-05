extends PlayerState
class_name PlayerFrozen


func physics_update(delta):
	player.move_velocity = Vector3.ZERO
	player.vertical_velocity = Vector3.ZERO


func unfreeze():
	transition.emit(self, "InAir")
