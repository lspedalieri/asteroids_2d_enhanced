extends CanvasLayer

func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("pause_toggle"):
		Global.paused = not Global.paused
		get_tree().set_pause(Global.paused)
		get_node("pause_popup").visible = Global.paused
		get_node("message").visible = not Global.paused

func update(player):
	update_shield(player.shield_level)
	get_node("score").set_text(str(Global.score))
	get_node("shield_val").set_text(str(floor(player.shield_level)))
	
func update_shield(shield_level):
	var color = "green"
	if shield_level < 40:
		color = "red"
	elif shield_level < 70:
		color = "yellow"
	var texture = load("res://art/gui/barHorizontal_%s_mid 200.png" % color)
	get_node("shield_bar").set_progress_texture(texture)
	get_node("shield_bar").set_value(shield_level)

func show_message(text):
	get_node("message").set_text(text)
	get_node("message").show()
	get_node("message_timer").start()

func _on_message_timer_timeout():
	get_node("message").hide()
