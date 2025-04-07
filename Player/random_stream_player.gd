extends AudioStreamPlayer
class_name RandomStreamPlayer


@export var streams: Array[AudioStream]


func play_random(from_position: float = 0.0):
	if streams and streams.is_empty():
		return
	stream = streams.pick_random()
	play(from_position)
