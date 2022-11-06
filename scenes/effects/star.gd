extends Sprite

onready var oscale = scale

func _process(delta):
	scale = oscale * rand_range(0.5,0.6)
	global_rotation = 0
