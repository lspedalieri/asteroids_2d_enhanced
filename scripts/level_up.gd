extends Control

func _ready():
	#print("Level up")
	$Particles2D.one_shot = true
	$Particles2D.emitting = true
	$AnimationPlayer.play("levelup")
	#queue_free()
