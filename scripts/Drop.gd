extends RigidBody2D

export var speed = 50
var extents
var node_textures = Global.powerup_textures
var type

signal pickup

func _ready():
	add_to_group("powerups")
	getTexture()
	linear_velocity = Vector2(speed, 0).rotated(rand_range(0, 2*PI))

func _on_Lifetime_timeout():
	queue_free()


func getIndex():
	var index = randf() * 100
	if index >= 90:
		return "gold"
	elif index >= 60:
		return "silver"
	else:
		return "bronze"
	
func getTexture():
	type = getIndex()
	var texture = load(node_textures[type])
	get_node("sprite").set_texture(texture)
	extents = texture.get_size() / 2
	var shape = CircleShape2D.new()
	#give a proper size of the collision shape of the drop
	shape.radius = min(texture.get_width(), texture.get_height())
	return shape

