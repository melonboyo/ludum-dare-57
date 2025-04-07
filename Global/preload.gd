extends Node


var main_scene: PackedScene = preload("res://Level/level.tscn")
var rope_hinge_scene: PackedScene = preload("res://Player/rope_hinge.tscn")
var rope_end_scene: PackedScene = preload("res://Player/rope_end.tscn")

var rope_hinge_instance: RopeHinge
var rope_end_instance: RopeEnd


func _ready() -> void:
	pass
	#rope_hinge_instance = rope_hinge_scene.instantiate()
	#rope_end_instance = rope_end_scene.instantiate()
	
	#get_parent().get_node("Level").add_child(rope_hinge_instance)
	#get_parent().get_node("Level").add_child(rope_end_instance)
	
	#rope_hinge_instance.global_position = Vector3.RIGHT * 10
	#rope_end_instance.global_position = Vector3.RIGHT * 10
	#await get_tree().create_timer(0.1).timeout
	#rope_hinge_instance.queue_free()
	#rope_end_instance.queue_free()
