extends Control

onready var title_animation = get_node("TitleStartingAnimation")
onready var start = get_node("Menu/Start")
onready var quit = get_node("Menu/Quit")
onready var title = get_node("Title")
onready var title_container = get_node("TitleContainer")

var letters = preload("res://scenes/letters.tscn")
var title_letter
var font = "terminator"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.preloadLetters("terminator")
	#title_animation.play("start title")
	for character in Global.title_coordinates:
		title_letter = letters.instance()
		$TitleContainer.add_child(title_letter)
		title_letter.init(character, font, 0.5)

func _on_Start_pressed():
	#SceneTransition.change_scene("res://scenes/main.tscn")
	Global.new_game()
	
func _on_Quit_pressed():
	print("quit")
	get_tree().root.queue_free()
	
func _on_Leaderboard_pressed():
	get_tree().change_scene("res://scenes/leaderboard_table.tscn")


func sceneTransition():
	pass
