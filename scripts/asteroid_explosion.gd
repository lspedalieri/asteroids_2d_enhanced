extends Particles2D

onready var explosion_sounds = get_node("explosion_sounds")

func _ready():
	#print("asteroid explosion")
	one_shot = true
	emitting = true
	#queue_free()


func play_explosion_sounds():
	explosion_sounds.get_child(randi() % (8)).play()
