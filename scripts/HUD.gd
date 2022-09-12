extends CanvasLayer

var texture_bar = load("res://art/gui/barHorizontal_white_mid.png")
var color = Global.white
var label
var ms = 0
var s = 0
var m = 0
var time_last := ""
var shield_up = true
onready var shield_bar = $shield_bar
onready var shield_repair = $shield_repair
onready var message_label = $message
onready var bronze_gauge = $powerups/bronze
onready var silver_gauge = $powerups/silver
onready var gold_gauge = $powerups/gold
onready var enter_name_screen = $enter_name_screen

func _ready():
	ms = Global.chrono
	gold_gauge.value = 0 #Global.powerup_counter.gold
	silver_gauge.value = 0 #Global.powerup_counter.silver
	bronze_gauge.value = 0 #Global.powerup_counter.bronze
	pass # Replace with function body.
	#set_process(true)
	shield_repair.max_value = Global.shield_repair[Global.upgrade_level['shield_regen']]
	$chronometer/ms.wait_time=0.1
	$chronometer/ms.start()

func _process(delta):
	if not Global.paused:
		chronometer()
	
func chronometer():
	if ms > 9:
		s += 1
		ms = 0
	if s > 59:
		m += 1
		s = 0
	time_last = str(m)+":"+str(s)+":"+str(ms)
	$chronometer.set_text(time_last)

func _input(event):
	if event.is_action_pressed("pause_toggle"):
		Global.paused = not Global.paused
		get_tree().set_pause(Global.paused)
		get_node("pause_popup").visible = Global.paused
		message_label.visible = not Global.paused

func update(player):
	update_shield(player.shield_level)
	get_node("score").set_text(str(Global.score))
	get_node("shield_val").set_text(str(floor(player.shield_level)))
	
func update_shield(shield_level):
		
	if shield_level > 70:
		color = Global.blue
	elif shield_level > 40:
		color = Global.yellow
	elif shield_level > 0:
		color = Global.red

	if shield_level == 100:
		color = Global.white

	if shield_level == 0:
		#shield_repair.value = 0
		#startShieldRepair()
		color = Global.black

	if shield_level > 0:
		shield_bar.show()
		shield_repair.hide()

	shield_bar.set_tint_progress(color)
	shield_bar.set_progress_texture(texture_bar)
	shield_bar.set_value(shield_level)

func startShieldRepair():
	shield_up = false
	print("start shield repair")
	print(shield_repair.max_value)
	shield_bar.hide()
	shield_repair.show()
	$shield_repair.value = 0
	$shield_repair_timer.wait_time = shield_repair.max_value
	$shield_repair_timer.start()

func updatePowerups():
	for node in $powerups.get_children():
		if node.name == "gold":
			color = Global.yellow
			label = $powerups/gold/label
		elif node.name == "silver":
			color = Global.light_grey
			label = $powerups/silver/label
		elif node.name == "bronze":
			color = Global.red
			label = $powerups/bronze/label
		node.set_tint_progress(color)
		node.set_progress_texture(texture_bar)
		node.set_value(Global.powerup_counter[node.name] % 5)
		label.set_text(String(Global.powerup_counter[node.name]))

func show_message(text):
	message_label.set_text(text)
	message_label.show()
	get_node("message_timer").start()

func _on_message_timer_timeout():
	message_label.hide()


func _on_ms_timeout():
	ms += 1
	$shield_repair.value+=0.1


func _on_shield_repair_timer_timeout():
	shield_up = true
	shield_bar.show()
	shield_bar.value = 1
	shield_repair.hide()

func _on_enter_name_button_pressed():
	Global.leaderboard_score.name = $enter_name_screen/enter_name.text
	Global.leaderboard_data.append(Global.leaderboard_score)
	Global.leaderboard()
	#SceneTransition.change_scene("res://scenes/leaderboard_table.tscn")
	#get_tree().change_scene("res://scenes/leaderboard_table.tscn")
#	Global.paused = not Global.paused
#	get_tree().set_pause(Global.paused)

func _on_Quit_pressed():
	Global.leaderboard()
	#SceneTransition.change_scene("res://scenes/leaderboard_table.tscn")
	Global.paused = not Global.paused
	get_tree().set_pause(Global.paused)
	#get_tree().root.queue_free()
