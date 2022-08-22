extends "res://scripts/bullet.gd"

var lifetime = 10

func _on_lifetime_timeout():
	queue_free()

func _on_player_bullet_body_entered(body):
	if body.get_groups().has("asteroids"):
		#delete the bullet
		queue_free()
		#body explode in 2 pieces in opposite directions
		body.life -= 1
		if body.life == 0:
			body.explode(vel.normalized())
		else:
			body.life_label.set_text(String(body.life))

			

func _on_player_bullet_area_entered( area ):
	if area.is_in_group("enemies"):
		queue_free()
		area.damage(Global.bullet_damage)
