extends RigidBody3D
class_name RopeEnd


var initial_impulse: Vector3 = Vector3.ZERO
var roll := false


func _ready() -> void:
	apply_central_impulse(initial_impulse)


func _physics_process(delta: float) -> void:
	if not roll:
		return
	
	var direction := initial_impulse.normalized().x * Vector3.RIGHT
	constant_force = direction * initial_impulse.length() * 1.2 + Vector3.UP * 1.2
