extends Control

var row = preload("res://scenes/leaderboard_rows.tscn")
onready var table = get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer")
onready var start = get_node("Start")
onready var quit = get_node("Quit")

var sn = 0
var data = Global.leaderboard_data

#Aggiunge dati all'elenco della leaderboard
func set_data(data:Dictionary):
	sn = sn + 1
	var instance = row.instance()
	instance.name = str(sn)
	table.add_child(instance)
	instance.connect("pressed", self, "_on_button_pressed")
	
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/1").text = data.name
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/2").text = str(data.score)
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/3").text = str(data.time)
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/4").text = str(Time.get_datetime_string_from_unix_time(data.date))
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/5").text = str(data.accuracy)+"%"

func _ready():
	$music.play()
	for i in range(data.size()):
		set_data(data[i])

func _on_Start_pressed():
	print("start")
	#var a = SceneTransition.instance()
	SceneTransition.change_scene("res://scenes/main.tscn")
	#get_tree().change_scene("res://scenes/main.tscn")
	
func _on_Quit_pressed():
	print("quit")
	get_tree().root.queue_free()
