####################################
#
#	Main scene n°1
#	First Quest Arc
#	Classic Asteroid with powerups
#
####################################

extends Node


#Preload node scenes
var asteroid = preload("res://scenes/asteroid.tscn")
var enemy = preload("res://scenes/enemy.tscn")
var drop = preload("res://scenes/drop.tscn")
var player_explosion = preload("res://scenes/effects/player_explosion.tscn")
var asteroid_explosion = preload("res://scenes/effects/asteroid_explosion.tscn")
var drop_explosion = preload("res://scenes/effects/drop_explosion.tscn")
var enemy_explosion = preload("res://scenes/effects/enemy_explosion.tscn")

#Load Global variables
onready var asteroid_template = Global.asteroid_template
onready var spawns = get_node("spawn_locations")
onready var asteroid_container = get_node("asteroid_container")
onready var HUD = get_node("HUD")
onready var expl_sounds = get_node("expl_sounds")
onready var player = get_node("player")
onready var enemy_timer = get_node("Timers/enemy_timer")
onready var restart_timer = get_node("Timers/restart_timer")

##################################################

func _ready():
	print("main ready")
	#HUD.enter_name_screen.hide()
	set_process(true)
	get_node("music/backmusic1").play()
	player.connect("explode", self, "explode_player")
	player.connect("upgrade", self, "upgrade_message")
	player.connect("shield_down", self, "shield_repair")
	begin_next_level(true)

#Main Game Loop
func _process(delta):
	HUD.update(player)
	if asteroid_container.get_child_count() == 0:
		begin_next_level(false)

#Start level
#Can start from first level or the next one
#It calls the right number of asteroids depending on Wave number (Global.level)
func begin_next_level(start):
	if !start:
		Global.level += 1
	enemy_timer.stop()
	enemy_timer.set_wait_time(Global.enemy_timer)
	enemy_timer.start()
	HUD.show_message("Wave %s" % Global.level)
	for i in range(Global.level):
		var asteroid_vars = init_asteroid_vars()
		spawn_asteroid(asteroid_vars[0], asteroid_vars[1], asteroid_vars[2], asteroid_vars[3])

#Returns Initialize asteroid properties (size, position, velocity, life)
func init_asteroid_vars() -> Array:
	var size = Global.asteroid_sizes[randi() % Global.asteroid_sizes.size() - 1]
	var pos = spawns.get_child(randi() % (Global.spawn_locations_num -1)).get_position()
	var vel = Vector2(rand_range(30, 100), 0).rotated(rand_range(0, 5*PI))
	var life = Global.asteroid_properties[size].life
	return [size, pos, vel, life]

#########################
#
#	Spawn objects
#
#########################


func spawn_asteroid(size, pos, vel, life):
	var ast = asteroid.instance()
	asteroid_container.add_child(ast)
	ast.connect("explode", self, "explode_asteroid")
	ast.init(size, pos, vel, life)

func spawn_powerup(pos):
	print("spawn powerup")
	var d = drop.instance()
	d.position = pos
	add_child(d)
	d.connect("explode", self, "explode_drop")

func spawn_enemy():
	var expl = enemy.instance()
	add_child(expl)
	expl.target = player
	expl.connect("explode", self, "explode_enemy")
	enemy_timer.set_wait_time(rand_range(20, 40))
	enemy_timer.start()


#########################
#
#	Explode objects
#
#########################

func explode_asteroid(size, pos, vel, hit_vel):
	var newsize = Global.break_pattern[size]
	if newsize:
		for offset in [-10 ,10]:
			var newpos = pos + hit_vel.tangent().clamped(Global.explode_distance) * offset
			var newvel = (vel + hit_vel.tangent()) * 2 * offset
			spawn_asteroid(newsize, newpos, newvel, Global.asteroid_properties[newsize].life)
	#print("asteroid explosion animation")
	var expl = asteroid_explosion.instance()
	$explosion_container.add_child(expl)
	expl.set_scale(Vector2(1.0 / (Global.break_pattern.keys().find(size) + 1), 1.0 / (Global.break_pattern.keys().find(size) + 1)))
	expl.set_position(pos)
	expl.play_explosion_sounds()
	if randf() < Global.asteroid_properties[size].drop_chance:
		spawn_powerup(pos)

func explode_player(accuracy):
	print("accuracy")
	print(accuracy)
	player.disable()
	var expl = player_explosion.instance()
	$explosion_container.add_child(expl)
	expl.play_explosion_sounds()
	#expl.set_scale(Vector2(1.0 / (Global.break_pattern.keys().find(size) + 1), 1.0 / (Global.break_pattern.keys().find(size) + 1)))
	expl.set_position(player.pos)
	
#	var expl = player_explosion.instance()
#	add_child(expl)
#	#expl.scale(Vector2(1.5, 1.5))
#	expl.set_position(player.pos)
#	expl.play()
#	expl.play_explosion_sounds()

	HUD.show_message(Global.messages['game_over'])
	Global.leaderboard_score = {'score' : HUD.get_node("score").text, 'name':Global.username, 'time': HUD.time_last, 'date':Time.get_unix_time_from_system(), 'accuracy': accuracy}
	#Global.leaderboard_data.append(leaderboard_score)
	print("ship exploded")
	restart_timer.start()
	

func explode_enemy(pos):
	var expl = enemy_explosion.instance()
	$explosion_container.add_child(expl)
	expl.play_explosion_sounds()
	#expl.set_scale(Vector2(1.0 / (Global.break_pattern.keys().find(size) + 1), 1.0 / (Global.break_pattern.keys().find(size) + 1)))
	expl.set_position(pos)
	for a in Global.level * 2:
		spawn_powerup(pos)

func explode_drop(pos):
	var expl = drop_explosion.instance()
	$explosion_container.add_child(expl)
	expl.set_position(pos)

#########################
#
#	Timers
#
#########################

func _on_restart_timer_timeout():
	HUD.enter_name_screen.show()
	#Global.new_game()

func _on_enemy_timer_timeout():
	spawn_enemy()

func _on_player_pickup(body):
	#print(body.type)
	#Global.powerup_counter[body.type] += 1
	HUD.updatePowerups()
	#player.checkUpgrades()
	
	#print(Global.powerup_counter)
	#$HUD.update_cash(global.cash)
	body.queue_free()

#########################
#
#	HUD
#
#########################

func upgrade_message(message):
	HUD.show_message(message + " Upgraded")

func shield_repair():
	HUD.startShieldRepair()
	
func powerupMessage(message):
	HUD.show_message(message)
