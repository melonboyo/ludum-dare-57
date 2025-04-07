extends PlayerState
class_name PlayerOnLedge


@export var land_player: AudioStreamPlayer

@export_subgroup("Ledge Detection")
@export var ledge_top_ray: RayCast3D
@export var ledge_bottom_ray: RayCast3D
@export var ledge_check_ray: RayCast3D
@export var ledge_timer: Timer
@export var ledge_leave_timer: Timer

var ledge_direction := Vector2.UP
var ledge_normal := Vector2.UP
var ledge_position := Vector3.ZERO
var ledge_position_top := Vector3.ZERO

const PLAYER_RADIUS := 0.55


func enter():
	player.play_animation("onledge")
	land_player.play()
	
	ledge_check_ray.force_raycast_update()
	ledge_top_ray.force_raycast_update()
	ledge_bottom_ray.force_raycast_update()
	ledge_position = ledge_bottom_ray.get_collision_point()
	var ledge_normal3 := ledge_bottom_ray.get_collision_normal()
	ledge_normal = Vector2(ledge_normal3.x, 0.0).normalized()
	ledge_position_top = ledge_check_ray.get_collision_point()
	ledge_position = Vector3(ledge_position.x, ledge_position_top.y - 0.07, 0.0)
	var ledge_direction3 = player.global_position.direction_to(ledge_position)
	ledge_direction = Vector2(ledge_direction3.x, ledge_direction3.y).normalized()
	ledge_position = ledge_position - Vector3(ledge_direction.x, 0.0, 0.0).normalized() * PLAYER_RADIUS
	player.global_position = ledge_position
	rotate_to_direction_instant(-ledge_normal.x)
	player.last_strong_move_input = -ledge_normal.x
	
	player.velocity = Vector3.ZERO
	player.move_velocity = Vector3.ZERO
	player.vertical_velocity = Vector3.ZERO


func update(delta):
	super(delta)
	
	if player.in_climb_area:
		if Input.is_action_just_pressed("up"):
			transition.emit(self, "Climbing")
			return
	
	if Input.is_action_just_pressed("down"):
		leave_ledge()
		return
	
	if (
		abs(player.input_direction.normalized().angle_to(-ledge_normal)) > 0.7*PI and 
		absf(player.move_input) > 0.95
	):
		if ledge_leave_timer.is_stopped():
			ledge_leave_timer.start()
	else:
		ledge_leave_timer.stop()


func leave_ledge():
	ledge_timer.start()
	transition.emit(self, "InAir")


func physics_update(delta):
	if player.in_climb_area:
		if Input.is_action_just_pressed("up"):
			transition.emit(self, "Climbing")
			return
	
	if Input.is_action_just_pressed("jump"):
		ledge_timer.start()
		player.jump(true)
		transition.emit(self, "InAir")
		return
	
	player.move_velocity = Vector3.ZERO
	player.vertical_velocity = Vector3.ZERO


func _on_ledge_leave_timer_timeout() -> void:
	leave_ledge()
