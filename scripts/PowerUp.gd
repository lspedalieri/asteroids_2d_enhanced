extends Area2D

var vel = Vector2()
var speed = 200

func ready():
	set_process(true)
	
func _process(delta):
	set_position(get_position() + vel * delta)
	
func start_at(dir, pos):
	#print(dir)
	#print(pos)
	set_rotation(dir)
	set_position(pos)
	vel = Vector2(speed, 0).rotated(dir + PI/2)

func intercepted():
	queue_free()
	
func _on_visible_screen_exited():
	queue_free()
