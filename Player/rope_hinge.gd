@tool
extends RigidBody3D
class_name RopeHinge

@export var debug := true:
	set(value):
		if not Engine.is_editor_hint():
			return
		debug = value
		for c in find_children("Debug"):
			c.visible = debug
var initial_impulse: Vector3
@export var rope_end_scene: PackedScene
var rope_end: RopeEnd


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	rope_path = $RopePath
	apply_central_impulse(initial_impulse)


func _on_body_entered(body: Node) -> void:
	if Engine.is_editor_hint():
		return
	for b in get_colliding_bodies():
		pass
	freeze = true
	spawn_rope_end(linear_velocity)


func spawn_rope_end(impulse: Vector3):
	if Engine.is_editor_hint():
		return
	$RollTimer.start()
	rope_end = rope_end_scene.instantiate()
	rope_end.initial_impulse = impulse * 0.2
	add_child(rope_end)
	rope_end.global_position = global_position
	last_position = global_position
	$Hinges/Hinge1.global_position = global_position


var last_position: Vector3
@export var link_length := 0.4:
	set(value):
		link_length = value
		if not Engine.is_editor_hint():
			return
		for link in $Links.get_children():
			link.get_node("CollisionShape3D").shape.height = value
			link.get_node("CollisionShape3D").position.y = value*0.5
			link.get_node("Mesh").mesh.height = value + value*0.8
			link.get_node("Mesh").position.y = value*0.1
var current_link := 1
var link_count := 13
var rope_path: Path3D:
	set(value):
		rope_path = value
		GameState.current_rope_path = value


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if not rope_end:
		return
	#if Input.is_action_pressed("down"):
		#%RopePathFollow.progress_ratio += 0.2 * delta
	#elif Input.is_action_pressed("up"):
		#%RopePathFollow.progress_ratio -= 0.2 * delta
	%RopePathFollow.progress_ratio = clampf(%RopePathFollow.progress_ratio, 0, 1)
	var j := 0
	while j < current_link and not j > link_count-1:
		var point_position: Vector3 = $Links.get_node("Link" + str(j+1)).position
		if $RopePath.curve.point_count <= j:
			$RopePath.curve.add_point(point_position)
		else:
			$RopePath.curve.set_point_position(j, point_position)
		#print(i)
		j += 1
	#if Input.is_action_pressed("run"):
		#$Links.get_node("Link" + str(link_count)).add_constant_central_force(Vector3.RIGHT * 4.0)
	var distance := rope_end.global_position.distance_to(last_position)
	if current_link > link_count:
		return
	if distance > link_length:
		var direction := last_position.direction_to(rope_end.global_position)
		var link_rotation := Vector3.UP.signed_angle_to(direction, Vector3.BACK)
		#print(rad_to_deg(link_rotation))
		if current_link + 1 <= link_count:
			$Hinges.get_node("Hinge" + str(current_link + 1)).global_position = rope_end.global_position
			#$Hinges.get_node("Hinge" + str(current_link + 1)).global_rotation.z = link_rotation
			#$Hinges.get_node("Hinge" + str(current_link + 1)).look_at(rope_end.global_position, Vector3.DOWN)
			#$Hinges.get_node("Hinge" + str(current_link + 1)).global_rotation.z += PI
			$Links.get_node("Link" + str(current_link)).get_node("Mesh").target = $Links.get_node("Link" + str(current_link+1))
		var link_position := last_position
		$Links.get_node("Link" + str(current_link)).global_position = link_position
		$Links.get_node("Link" + str(current_link)).global_rotation.z = link_rotation
		#$Links.get_node("Link" + str(current_link)).look_at(rope_end.global_position, Vector3.LEFT)
		#$Links.get_node("Link" + str(current_link)).global_rotation.z += 0.5*PI
		$Links.get_node("Link" + str(current_link)).freeze = false
		$Links.get_node("Link" + str(current_link)).get_node("Mesh").visible = true
		$Links.get_node("Link" + str(current_link)).get_node("CollisionShape3D").disabled = false
		$Links.get_node("Link" + str(current_link)).linear_velocity = Vector3.ZERO
		if current_link > 1:
			$Hinges.get_node("Hinge" + str(current_link)).node_a = $Hinges.get_node("Hinge" + str(current_link)).get_path_to($Links.get_node("Link" + str(current_link-1)))
		else:
			$Hinges/Hinge1.node_a = $Hinges/Hinge1.get_path_to(self)
		$Hinges.get_node("Hinge" + str(current_link)).node_b = $Hinges.get_node("Hinge" + str(current_link)).get_path_to($Links.get_node("Link" + str(current_link)))
		last_position = rope_end.global_position
		current_link += 1
		if current_link > link_count:
			#rope_end.freeze = true
			$Hinges.get_node("Hinge" + str(link_count+1)).global_position = rope_end.global_position
			$Hinges.get_node("Hinge" + str(link_count+1)).node_a = $Hinges.get_node("Hinge" + str(link_count+1)).get_path_to($Links.get_node("Link" + str(link_count)))
			$Hinges.get_node("Hinge" + str(link_count+1)).node_b = $Hinges.get_node("Hinge" + str(link_count+1)).get_path_to(rope_end)
			#$Hinges.reparent(get_parent())
			#$Links.reparent(get_parent())


func _on_roll_timer_timeout() -> void:
	if current_link < 3:
		delete()


func delete():
	queue_free()
