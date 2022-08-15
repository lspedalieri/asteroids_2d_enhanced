extends "res://scripts/bullet.gd"

func _on_enemy_bullet_area_entered(area):
	if area.has_method("damage") and not area.get_groups().has("enemies"):
		queue_free()
		area.damage(Global.enemy_bullet_damage)
