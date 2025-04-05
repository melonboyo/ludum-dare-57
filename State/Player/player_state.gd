extends State
class_name PlayerState


@onready var player: Player = get_node_or_null("../..")


func freeze():
	transition.emit(self, "Frozen")


func unfreeze():
	pass


func rotate_to_direction(dir: float, delta: float):
	var rotation = 0 if dir < 0 else PI
	player.rotation.y = lerp_angle(player.rotation.y, rotation, player.rotation_speed * delta)


func rotate_to_direction_instant(dir: float):
	var rotation = 0.5*PI if dir > 0 else 1.5*PI
	player.rotation.y = rotation
