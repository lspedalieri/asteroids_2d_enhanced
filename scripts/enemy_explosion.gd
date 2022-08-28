extends Particles2D

func _ready():
	#print("enemy explosion")
	one_shot = true
	emitting = true
	#queue_free()

func play_explosion_sounds():
	print("enemy explosion sound")
	$explosion.play()
