extends Node2D

var selection := "play"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cursor.position.y = 193
	selection = "play"


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
