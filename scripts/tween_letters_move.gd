extends Sprite


# Declare member variables here. Examples:
onready var title_animation = get_node("../TitleStartingAnimation")
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var x = position.x
	title_animation.play("start title")
	move_to_coordinates(x, 165, 2.0)
	#move_to_coordinates(x, 125, 0.5)

func move_to_coordinates(x, y, t) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", Vector2(x,y), t)
	yield(tween, "finished")
	
