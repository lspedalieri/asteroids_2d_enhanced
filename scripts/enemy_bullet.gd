extends "res://scripts/bullet.gd"

#Chiama il metodo _on_player_body_entered quando il proiettile si scontra con l'area del giocatore.
func _on_enemy_bullet_area_entered(area):
	print("enemy bullet")
	if area.has_method("_on_player_body_entered") and not area.get_groups().has("enemies"):
		queue_free()
		area._on_player_body_entered(self)
