extends Control

var node = preload("res://scenes/project/Node.tscn")

func _ready():
	pass


func _on_Button_pressed():
	var new_node = node.instance()
	add_child(new_node)
