extends KinematicBody2D

signal explode

onready var puff = get_node("puff")
onready var asteroid_collider = get_node("asteroid_collider")
export var bounce = 1.1


var size
var vel = Vector2()
var max_vel = 300
var rot_speed
var screen_size
var extents
var node_textures = Global.asteroid_textures

func _ready():
	add_to_group("asteroids")
	randomize()
	set_process(true)
	rot_speed = rand_range(-1.5 , 1.5)
	screen_size = get_viewport_rect().size

#Creazione degli asteroidi. Randomizzati per grandezza e forma
#La grandezza della collision shape viene decisa in base allo sprite scelto 
func init(init_size, init_pos, init_vel):
	size = init_size
	if init_vel.length() > 0:
		vel = init_vel
	else:
		vel = Vector2(rand_range(30, 100), 0).rotated(rand_range(0, 2*PI))
	rot_speed = rand_range(-1.5, 1.5)
	asteroid_collider.set_shape(getTexture())
	set_position(init_pos)

func getTexture():
	var texture = load(node_textures[size][randi() % node_textures[size].size()])
	get_node("sprite").set_texture(texture)
	extents = texture.get_size() / 2
	var shape = CircleShape2D.new()
	#give a proper size of the collision shape of the asteroids
	shape.radius = min(texture.get_width(), texture.get_height())
	return shape
	

func _process(delta):
	vel = vel.clamped(Global.asteroid_max_vel)
	set_rotation(get_rotation() + rot_speed * delta)
	var collision = move_and_collide(vel * delta)
	if collision:
		#vel += get_collision_normal() * (get_collider().vel.length() * bounce)
		vel = vel.bounce(collision.normal)
		puff.global_position = collision.position  
		puff.emitting = true
	# wrap around screen edges
	var pos = get_position()
	if pos.x > screen_size.x + extents.x:
		pos.x = -extents.x
	if pos.x < -extents.x:
		pos.x = screen_size.x + extents.x
	if pos.y > screen_size.y + extents.y:
		pos.y = -extents.y
	if pos.y < -extents.y:
		pos.y = screen_size.y + extents.y
	set_position(pos)
	
func explode(hit_vel):
	emit_signal("explode", size, get_position(), vel, hit_vel)
	Global.score += Global.ast_points[size]
	queue_free()
