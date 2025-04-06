@tool
extends CharacterBody3D
class_name Player


@export_subgroup("Controller")
@export var disable_input := false
@export_range(1.0, 1000.0) var walk_speed := 5.0
@export_range(1.0, 100.0) var run_speed := 7.5
@export_range(1.0, 100.0) var ground_acceleration := 50.0
@export_range(1.0, 100.0) var air_acceleration := 40.0
## If true, jump is performed by holding the jump button then releasing it
#@export var hold_to_jump := false
@export_range(0.0, 10.0) var jump_height := 1.35
@export_range(0.5, 100.0) var gravity := 50.0
@export_range(0.5, 100.0) var max_fall_speed := 15.0
@export_range(0.01, 100.0) var rotation_speed := PI*6.0

@export_subgroup("Ledge Detection")
@export_range(0.001, 3.0) var ledge_ray_length := 0.8:
	set(value):
		ledge_ray_length = value
		if not Engine.is_editor_hint():
			return
		var height_diff = (%LedgeTopRayCasts.global_position.y - %LedgeBottomRayCasts.global_position.y)
		#print(cos(floor_max_angle))
		var top_diff = height_diff / sin(floor_max_angle)
		for c: RayCast3D in %LedgeTopRayCasts.get_children():
			#c.target_position.z = value + top_diff
			c.target_position.z = value
		for c: RayCast3D in %LedgeBottomRayCasts.get_children():
			c.target_position.z = value
		%LedgeCheckRayCasts.position.z = value
		for c: RayCast3D in %LedgeCheckRayCasts.get_children():
			pass

@export_subgroup("Animation")
@export var animation: AnimationPlayer

@export_subgroup("Rope")
@export var rope_scene: PackedScene
var in_climb_area := false
var can_throw_rope := true
var rope_links_in_area: Array[Node3D]

@export_subgroup("Debug")
@export_node_path("MeshInstance3D") var debug_mesh_path: NodePath = NodePath("DebugMesh")

signal state_changed(prev: State, cur: State)
@onready var current_state: Constants.PlayerState = Constants.StringToPlayerStateLookup[$State.initial_state.name]

@onready var debug_mesh: MeshInstance3D = get_node(debug_mesh_path)
var move_velocity := Vector3.ZERO
var vertical_velocity := Vector3.ZERO
var jump_velocity := 0.0
var is_running := false
@onready var speed := walk_speed

var input_direction := Vector2.ZERO
var move_input := 0.0
var vertical_input := 0.0
var last_strong_move_input := 1.0

func _ready():
	if Engine.is_editor_hint():
		return
	
	jump_velocity = sqrt(2.0 * gravity * jump_height)
	for c in $State.get_children():
		if c is State:
			c.transition.connect(_on_state_transition)
	#set_debug_color(Constants.PlayerStateToColorLookup[current_state])


func _process(delta: float):
	if Engine.is_editor_hint():
		return
	
	if disable_input:
		return
	
	if (
		$RopeThrowCooldown.is_stopped() and 
		(current_state == Constants.PlayerState.IDLE or current_state == Constants.PlayerState.RUNNING)
	):
		can_throw_rope = true
	
	is_running = Input.is_action_pressed("run")
	speed = walk_speed
	#speed = walk_speed if not is_running else run_speed
	
	input_direction = Input.get_vector("left", "right", "down", "up")
	
	# Normalize direction if vector has length larger than 1
	if input_direction.length() > 1.0:
		input_direction = input_direction.normalized()
	
	move_input = input_direction.x
	vertical_input = input_direction.y
	
	if (
		not current_state == Constants.PlayerState.ONLEDGE and
		not current_state == Constants.PlayerState.THROWING and
		absf(move_input) > 0.05
	):
		last_strong_move_input = move_input


func _physics_process(delta: float):
	if Engine.is_editor_hint():
		return
	
	in_climb_area = rope_links_in_area and not rope_links_in_area.is_empty()
	
	# Add velocity from gravity and movement input together
	velocity = move_velocity + vertical_velocity
	
	# Move and slide the player character
	move_and_slide()
	move_velocity = Vector3(velocity.x, 0, 0)


func jump(apply_horizontal: bool = false):
	vertical_velocity += Vector3.UP * jump_velocity
	if apply_horizontal:
		move_velocity = Vector3.RIGHT * move_input * walk_speed


func set_debug_color(color: Color):
	if not debug_mesh:
		return
	debug_mesh.material_override.set_shader_parameter("albedo", color)


func _on_state_transition(from_state: State, to_state_name: String):
	current_state = Constants.StringToPlayerStateLookup[to_state_name]
	#set_debug_color(Constants.PlayerStateToColorLookup[current_state])


func freeze():
	$State.current_state.freeze()


func unfreeze():
	$State.current_state.unfreeze()


func play_animation(name: String, reset_speed: bool = true) -> void:
	if animation.current_animation == name:
		return
	animation.play(name)
	if reset_speed:
		animation.speed_scale = 1


func set_playback_speed(speed: float) -> void:
	animation.speed_scale = speed


func flip_sprite(value: bool) -> void:
	$Sprite.flip_h = value


func throw_rope() -> void:
	if GameState.current_rope:
		GameState.current_rope.delete()
	
	var new_rope: RopeHinge = rope_scene.instantiate()
	var facing_direction = (Vector3.RIGHT * last_strong_move_input).normalized()
	#new_rope.global_position = global_position + facing_direction * 1.5 + Vector3.UP * 1.5
	#new_rope.global_rotation.y = 0.0 if facing_direction.x >= 0.0 else PI
	new_rope.initial_impulse = (facing_direction + Vector3.UP) * 12.0 + get_real_velocity()
	get_parent_node_3d().add_child(new_rope)
	new_rope.global_position = global_position
	GameState.current_rope = new_rope
	#print(new_rope.initial_impulse)


func _on_climb_area_body_entered(body: Node3D) -> void:
	#print("enter")
	rope_links_in_area.append(body)


func _on_climb_area_body_exited(body: Node3D) -> void:
	#print("exit")
	rope_links_in_area.erase(body)
