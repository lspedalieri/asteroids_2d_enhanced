#########################################
#
#	Powerup Drop istance
#	Sistema di drop randomizzato
#	Ogni drop ha una durata prestabilita e alla fine emette un -
#	segnale al main per l'esplosione e si toglie dalla memoria
#	Può fare il giro della "ciambella"
#
#########################################

extends KinematicBody2D

export var vel = Vector2(50, 50)

var drop_explosion = preload("res://scenes/drop_explosion.tscn")

var extents
var node_textures = Global.powerup_textures
var type
var screen_size
var pos = Vector2()

signal explode

func _ready():
	add_to_group("powerups")
	getTexture()
	set_process(true)
	screen_size = get_viewport_rect().size
	$Lifetime.wait_time = Global.powerup_lifetime
	$Lifetime.start()

func _process(delta):
	var collision = move_and_collide(vel * delta)
	pos = get_position()
	if pos.x > screen_size.x:
		pos.x = 0
	if pos.x < 0:
		pos.x = screen_size.x
	if pos.y > screen_size.y:
		pos.y = 0
	if pos.y < 0:
		pos.y = screen_size.y
	set_position(pos)

#Sceglie un tipo di powerup a caso tra quelle disponibili
func getIndex():
	var index = randf() * 100
	if index >= 90:
		return "gold"
	elif index >= 60:
		return "silver"
	else:
		return "bronze"

#da una texture al node sprite e un raggio alla collision box
func getTexture():
	type = getIndex()
	var texture = load(node_textures[type])
	get_node("sprite").set_texture(texture)
	extents = texture.get_size() / 2
	var shape = CircleShape2D.new()
	#give a proper size of the collision shape of the drop
	shape.radius = min(texture.get_width(), texture.get_height())
	return shape

func _on_Lifetime_timeout():
	print("drop lifetime timeout")
	emit_signal("explode", get_global_position())
	queue_free()
