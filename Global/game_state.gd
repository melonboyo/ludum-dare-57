extends Node


var current_rope: RopeHinge = null
var current_rope_path_follow: PathFollow3D = null
var current_rope_path: Path3D = null:
	set(value):
		current_rope_path = value
		current_rope_path_follow = current_rope_path.get_node("RopePathFollow")
var player_state: Constants.PlayerState = Constants.PlayerState.IDLE
