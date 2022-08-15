extends Area2D

var vel = Vector2()
var speed = 1000

func ready():
	set_process(true)
	
func _process(delta):
	set_position(get_position() + vel * delta)
	
func start_at(dir, pos):
	set_rotation(dir)
	set_position(pos)
	#get_node("bullet").rotate(PI/2)
	vel = Vector2(speed, 0).rotated(dir + PI/2)

func _on_visible_screen_exited():
	queue_free()
