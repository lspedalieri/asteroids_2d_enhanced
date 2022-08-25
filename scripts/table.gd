extends Control

var row = preload("res://scenes/leaderboard_rows.tscn")
onready var table = get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer")
onready var start = get_node("Start")
onready var quit = get_node("Quit")

var sn = 0
var data = Global.leaderboard_data

func set_data(data:Dictionary):
	sn = sn + 1
	var instance = row.instance()
	instance.name = str(sn)
	table.add_child(instance)
	instance.connect("pressed", self, "_on_button_pressed")
	print(get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"))
	print(get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name))
	print(get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/1"))
	
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/1").text = data.name
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/2").text = str(data.score)
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/3").text = str(data.time)
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/4").text = str(Time.get_datetime_dict_from_datetime_string("YYYY-MM-DDTHH:MM:SS", false))

func _ready():
	for i in range(data.size()):
		set_data(data[i])

func _on_Start_pressed():
	get_tree().change_scene("res://scenes/main.tscn")
	
func _on_Quit_pressed():
	queue_free()
