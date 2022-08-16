extends CanvasLayer

var texture_bar = load("res://art/gui/barHorizontal_white_mid.png")
var color = Global.white
onready var shield_bar = $shield_bar
onready var message_label = $message
onready var bronze_gauge = $powerups/bronze
onready var silver_gauge = $powerups/silver
onready var gold_gauge = $powerups/gold

func _ready():
	gold_gauge.value = Global.powerup_counter.gold
	silver_gauge.value = Global.powerup_counter.silver
	bronze_gauge.value = Global.powerup_counter.bronze
	pass # Replace with function body.

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
	color = Global.yellow
	if shield_level < 40:
		color = Global.red
	elif shield_level < 70:
		color = Global.yellow
	shield_bar.set_tint_progress(color)
	shield_bar.set_progress_texture(texture_bar)
	shield_bar.set_value(shield_level)


func updatePowerups():
	for node in $powerups.get_children():
		if node.name == "gold":
			color = Global.yellow
		elif node.name == "silver":
			color = Global.light_grey
		elif node.name == "bronze":
			color = Global.red
		node.set_tint_progress(color)
		node.set_progress_texture(texture_bar)
		node.set_value(Global.powerup_counter[node.name] % 5)
	print(Global.powerup_counter)

func show_message(text):
	message_label.set_text(text)
	message_label.show()
	get_node("message_timer").start()

func _on_message_timer_timeout():
	message_label.hide()
