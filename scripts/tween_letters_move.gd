extends Sprite

onready var title_animation = get_node("../TitleStartingAnimation")


func _ready():
	var x = position.x
	title_animation.play("start title")
	move_to_coordinates(x, 165, 2.0)

func move_to_coordinates(x, y, t) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", Vector2(x,y), t)
	yield(tween, "finished")
	
