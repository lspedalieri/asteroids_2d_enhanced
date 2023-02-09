extends Node2D

var selection := "play"
onready var title_animation = get_node("TitleStartingAnimation")
onready var title = get_node("Title")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cursor.position.y = 193
	selection = "play"
	title_animation.play("start title")
	move_to_coordinates("Title", title.position.x, 165, 2.0)
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
