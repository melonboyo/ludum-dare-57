@tool
extends Node3D


@export var color: Color:
	set(value):
		#$OmniLight3D.light_color = color
		color = value
		pass
