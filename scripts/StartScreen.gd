extends Node2D

var selection := "play"
onready var title_animation = get_node("TitleStartingAnimation")
onready var title = get_node("Title")
var title_starting_coordinates = [
	{"A": Vector2(20, -20)},
	{"S": Vector2(40, -20)},
	{"T": Vector2(60, -20)},
	{"E": Vector2(80, -20)},
	{"R": Vector2(100, -20)},
	{"O": Vector2(120, -20)},
	{"I": Vector2(140, -20)},
	{"D": Vector2(160, -20)},
	{"S": Vector2(180, -20)},
	{"O": Vector2(220, -20)},
	{"N": Vector2(240, -20)},
	{"S": Vector2(280, -20)},
	{"T": Vector2(300, -20)},
	{"E": Vector2(320, -20)},
	{"R": Vector2(340, -20)},
	{"O": Vector2(360, -20)},
	{"I": Vector2(380, -20)},
	{"D": Vector2(400, -20)},
	{"S": Vector2(420, -20)},
]

var title_landing_coordinates = [
	{"A": Vector2(20, 165)},
	{"S": Vector2(40, 165)},
	{"T": Vector2(60, 165)},
	{"E": Vector2(80, 165)},
	{"R": Vector2(100, 165)},
	{"O": Vector2(120, 165)},
	{"I": Vector2(140, 165)},
	{"D": Vector2(160, 165)},
	{"S": Vector2(180, 165)},
	{"O": Vector2(220, 165)},
	{"N": Vector2(240, 165)},
	{"S": Vector2(280, 165)},
	{"T": Vector2(300, 165)},
	{"E": Vector2(320, 165)},
	{"R": Vector2(340, 165)},
	{"O": Vector2(360, 165)},
	{"I": Vector2(380, 165)},
	{"D": Vector2(400, 165)},
	{"S": Vector2(420, 165)},
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cursor.position.y = 193
	selection = "play"
	title_animation.play("start title")
	move_to_coordinates("Title", title.position.x, 165, 3.0)
	#move_to_coordinates(x, 125, 0.5)

func move_to_coordinates(node_name, x, y, t) -> void:
	var tween := get_node(node_name).create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(get_node(node_name), "global_position", Vector2(x,y), t)
	yield(tween, "finished")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		$Cursor.position.y = 193
		selection = "play"
		
	elif Input.is_action_just_pressed("ui_down"):
		$Cursor.position.y = 213
		selection = "credits"
		

	if Input.is_action_just_pressed("shoot"):
		if selection == "play":
			get_tree().change_scene("res://Screens/ScreenShipSelection.tscn")
		else:
			get_tree().change_scene("res://Screens/credits.tscn")
