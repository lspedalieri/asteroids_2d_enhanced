extends Node


func init(letter, init_pos):
	letter.set_position(init_pos)

func move_to_coordinates(node_name, x, y, t) -> void:
	var tween := get_node(node_name).create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(get_node(node_name), "global_position", Vector2(x,y), t)
	yield(tween, "finished")
