extends AnimatedSprite

func _on_explosion_finished():
	queue_free()
	
func play_explosion_sounds():
	get_node("explosion_sounds").get_child(randi() % (3)).play()
