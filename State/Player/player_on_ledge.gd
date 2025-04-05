extends PlayerState
class_name PlayerOnLedge


@export_subgroup("Ledge Detection")
@export var ledge_top_ray: RayCast3D
@export var ledge_bottom_ray: RayCast3D
@export var ledge_check_ray: RayCast3D
@export var ledge_timer: Timer

var ledge_direction := Vector2.UP
var ledge_normal := Vector2.UP
var ledge_position := Vector3.ZERO
var ledge_position_top := Vector3.ZERO

const PLAYER_RADIUS := 0.25


func enter():
	ledge_position = ledge_bottom_ray.get_collision_point()
	var ledge_normal3 := ledge_bottom_ray.get_collision_normal()
	ledge_normal = Vector2(ledge_normal3.x, 0.0).normalized()
	ledge_position_top = ledge_check_ray.get_collision_point()
	ledge_position = Vector3(ledge_position.x, ledge_position_top.y + 0.3, ledge_position.z)
	var ledge_direction3 = player.global_position.direction_to(ledge_position)
	ledge_direction = Vector2(ledge_direction3.x, ledge_direction3.z).normalized()
	ledge_position = ledge_position - Vector3(ledge_direction.x, 0.0, ledge_direction.y) * PLAYER_RADIUS
	player.global_position = ledge_position
	rotate_to_direction_instant(-ledge_normal.x)
	player.last_strong_move_input = -ledge_normal.x


func update(_delta):
	var release_ledge: bool = Input.is_action_just_pressed("cancel") or \
		(abs(player.input_direction.normalized().angle_to(-ledge_normal)) > 0.7*PI and player.input_direction.length() > 0.98)
	
	if release_ledge:
		ledge_timer.start()
		transition.emit(self, "InAir")
		return


func physics_update(delta):
	if Input.is_action_just_pressed("jump"):
		ledge_timer.start()
		player.jump()
		transition.emit(self, "InAir")
		return
	
	player.move_velocity = Vector3.ZERO
	player.gravity_velocity = Vector3.ZERO
