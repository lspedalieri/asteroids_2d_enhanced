extends Node2D

var selection := "play"
onready var title_animation = get_node("TitleStartingAnimation")
var letters = preload("res://scenes/letters.tscn")
onready var title = get_node("Title")
var title_starting_coordinates = [
	{"letter" : "A", "coords" : Vector2(20, -20)},
	{"letter" : "S", "coords" : Vector2(40, -20)},
	{"letter" : "T", "coords" : Vector2(60, -20)},
	{"letter" : "E", "coords" : Vector2(80, -20)},
	{"letter" : "R", "coords" : Vector2(100, -20)},
	{"letter" : "O", "coords" : Vector2(120, -20)},
	{"letter" : "I", "coords" : Vector2(140, -20)},
	{"letter" : "D", "coords" : Vector2(160, -20)},
	{"letter" : "S", "coords" : Vector2(180, -20)},
	{"letter" : "O", "coords" : Vector2(220, -20)},
	{"letter" : "N", "coords" : Vector2(240, -20)},
	{"letter" : "S", "coords" : Vector2(280, -20)},
	{"letter" : "T", "coords" : Vector2(300, -20)},
	{"letter" : "E", "coords" : Vector2(320, -20)},
	{"letter" : "R", "coords" : Vector2(340, -20)},
	{"letter" : "O", "coords" : Vector2(360, -20)},
	{"letter" : "I", "coords" : Vector2(380, -20)},
	{"letter" : "D", "coords" : Vector2(400, -20)},
	{"letter" : "S", "coords" : Vector2(420, -20)},
]

var title_landing_coordinates = [
	{"letter" : "A", "coords" : Vector2(20, 165)},
	{"letter" : "S", "coords" : Vector2(40, 165)},
	{"letter" : "T", "coords" : Vector2(60, 165)},
	{"letter" : "E", "coords" : Vector2(80, 165)},
	{"letter" : "R", "coords" : Vector2(100, 165)},
	{"letter" : "O", "coords" : Vector2(120, 165)},
	{"letter" : "I", "coords" : Vector2(140, 165)},
	{"letter" : "D", "coords" : Vector2(160, 165)},
	{"letter" : "S", "coords" : Vector2(180, 165)},
	{"letter" : "O", "coords" : Vector2(220, 165)},
	{"letter" : "N", "coords" : Vector2(240, 165)},
	{"letter" : "S", "coords" : Vector2(280, 165)},
	{"letter" : "T", "coords" : Vector2(300, 165)},
	{"letter" : "E", "coords" : Vector2(320, 165)},
	{"letter" : "R", "coords" : Vector2(340, 165)},
	{"letter" : "O", "coords" : Vector2(360, 165)},
	{"letter" : "I", "coords" : Vector2(380, 165)},
	{"letter" : "D", "coords" : Vector2(400, 165)},
	{"letter" : "S", "coords" : Vector2(420, 165)},
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cursor.position.y = 193
	selection = "play"
	title_animation.play("start title")


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
