extends CanvasLayer

var texture_bar = load("res://art/gui/barHorizontal_white_mid.png")
var color = Color(1,1,1,1)

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
	color = Color( 0, 1, 0, 1 )
	if shield_level < 40:
		color = Color( 1, 0, 0, 1 )
	elif shield_level < 70:
		color = Color( 0, 1, 0, 1 )
	$shield_bar.set_tint_progress(color)
	$shield_bar.set_progress_texture(texture_bar)
	$shield_bar.set_value(shield_level)


func updatePowerups():
	for node in $powerups.get_children():
		if node.name == "gold":
			color = Color( 0, 1, 0, 1 )
		elif node.name == "silver":
			color = Color( 0.8, 0.8, 0.8, 1 )
		elif node.name == "bronze":
			color = Color( 1, 0, 0, 1 )
		print("metto il powerup nella barra %s col valore %s", node.name, Global.powerup_counter[node.name])
		node.set_tint_progress(color)
		node.set_progress_texture(texture_bar)
		node.set_value(Global.powerup_counter[node.name] % 5)

func show_message(text):
	get_node("message").set_text(text)
	get_node("message").show()
	get_node("message_timer").start()

func _on_message_timer_timeout():
	get_node("message").hide()
