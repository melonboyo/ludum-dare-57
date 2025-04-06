extends RigidBody3D
class_name RopeEnd


var initial_impulse: Vector3 = Vector3.ZERO


func _ready() -> void:
	apply_central_impulse(initial_impulse)
