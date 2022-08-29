extends Node2D

onready var DisplayText = get_node("ColorRect/enter_name") 

func _on_Button_pressed():
	Global.leaderboard_score.name = DisplayText.text
	Global.leaderboard_data.append(Global.leaderboard_score)
	get_tree().change_scene("res://scenes/leaderboard_table.tscn")
