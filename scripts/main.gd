extends Node

var asteroid = preload("res://scenes/asteroid.tscn")
var player_explosion = preload("res://scenes/explosion.tscn")
var asteroid_explosion = preload("res://scenes/asteroid_explosion.tscn")
var drop_explosion = preload("res://scenes/drop_explosion.tscn")

var enemy = preload("res://scenes/enemy.tscn")
var drop = preload("res://scenes/Drop.tscn")

onready var spawns = get_node("spawn_locations")
onready var asteroid_container = get_node("asteroid_container")
onready var HUD = get_node("HUD")
onready var expl_sounds = get_node("expl_sounds")
onready var player = get_node("player")
onready var enemy_timer = get_node("Timers/enemy_timer")
onready var restart_timer = get_node("Timers/restart_timer")

func _ready():
	set_process(true)
	get_node("music/backmusic1").play()
	player.connect("explode", self, "explode_player")
	begin_next_level()
	
func begin_next_level():
	Global.level += 1
	enemy_timer.stop()
	enemy_timer.set_wait_time(rand_range(5, 5))
	enemy_timer.start()
	HUD.show_message("Wave %s" % Global.level)
	for i in range(Global.level):
		var asteroid_vars = init_asteroid_vars()
		spawn_asteroid(asteroid_vars[0], asteroid_vars[1], asteroid_vars[2])
	
func _process(delta):
	HUD.update(player)
	if asteroid_container.get_child_count() == 0:
		begin_next_level()
		
func spawn_asteroid(size, pos, vel):
	var a = asteroid.instance()
	asteroid_container.add_child(a)
	a.connect("explode", self, "explode_asteroid")
	a.init(size, pos, vel)

func spawn_powerup(pos):
	print("spawn powerup")
	var d = drop.instance()
	d.position = pos
	add_child(d)
	d.connect("explode", self, "explode_drop")


func init_asteroid_vars():
	var size = Global.asteroid_sizes[randi() % Global.asteroid_sizes.size() - 1]
	var pos = spawns.get_child(randi() % (Global.spawn_locations_num -1)).get_position()
	var vel = Vector2(rand_range(30, 100), 0).rotated(rand_range(0, 5*PI))
	return [size, pos, vel]

func explode_asteroid(size, pos, vel, hit_vel):
	var newsize = Global.break_pattern[size]
	if newsize:
		for offset in [-1 ,1]:
			var newpos = pos + hit_vel.tangent().clamped(Global.explode_distance) * offset
			var newvel = (vel + hit_vel.tangent()) * 2 * offset
			spawn_asteroid(newsize, newpos, newvel)
	#print("asteroid explosion animation")
	var expl = asteroid_explosion.instance()
	$explosion_container.add_child(expl)
	expl.set_scale(Vector2(1.0 / (Global.break_pattern.keys().find(size) + 1), 1.0 / (Global.break_pattern.keys().find(size) + 1)))
	expl.set_position(pos)
	#expl.play_explosion_sounds()
	if randf() < Global.asteroid_drop_chance:
		spawn_powerup(pos)

func explode_player():
	player.disable()
	var expl = player_explosion.instance()
	add_child(expl)
	#expl.scale(Vector2(1.5, 1.5))
	expl.set_position(player.pos)
	expl.play()
	expl.play_explosion_sounds()
	HUD.show_message("Game Over")
	restart_timer.start()

func explode_enemy(pos):
	var expl = player_explosion.instance()
	add_child(expl)
	expl.set_position(pos)
	expl.set_animation("sonic")
	expl.play()

func explode_drop(pos):
	var e = drop_explosion.instance()
	$explosion_container.add_child(e)
	e.set_position(pos)

func _on_restart_timer_timeout():
	Global.new_game()

func _on_enemy_timer_timeout():
	var e = enemy.instance()
	add_child(e)
	e.target = player
	e.connect("explode", self, "explode_enemy")
	enemy_timer.set_wait_time(rand_range(20, 40))
	enemy_timer.start()

func _on_player_pickup(body):
	print(body.type)
	Global.powerup_counter[body.type] += 1
	HUD.updatePowerups()
	player.checkUpgrades()
	
	#print(Global.powerup_counter)
	#$HUD.update_cash(global.cash)
	body.queue_free()
	
