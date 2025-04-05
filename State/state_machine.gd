extends Node
class_name StateMachine


@export var initial_state: State

var current_state: State
var states := {}


func _ready():
	for c in get_children():
		if c is State:
			states[c.name] = c
			c.transition.connect(_on_state_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _process(delta):
	if not current_state:
		return
	current_state.update(delta)


func _physics_process(delta):
	if not current_state:
		return
	current_state.physics_update(delta)


func _on_state_transition(from_state: State, to_state_name: String):
	if from_state != current_state:
		return
	
	var to_state = states.get(to_state_name)
	if !to_state:
		return
	
	if current_state:
		current_state.exit()
	
	to_state.enter()
	current_state = to_state
