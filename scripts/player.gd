########################################
#
#	Player
#	Movements: linear, rotation, acceleration, braking
#	Spawning over walls
#	Shooting (spawning bullets with proper momentum from muzzle position)
#	Colliding (on asteroids and enemies)
#	Damages (on shield and hull)
#	Collecting powerups (enhance properties with proper powerups)
#	Animation (thrusters, explosions)
#	Vengono emessi i segnali per gli upgrade, il pickup dei powerup e per l'esplosione verso main che li smista al giusto nodo/oggetto
#
########################################

extends Area2D

signal explode
signal pickup
signal upgrade
signal shield_down

#Var from Global
var fire_rate = Global.fire_rate[Global.upgrade_level['fire_rate']]
var rot_speed = Global.rot[Global.upgrade_level['rot']]
var thrust = Global.thrust[Global.upgrade_level['thrust']]
var shield_regen = Global.shield_regen[Global.upgrade_level['shield_regen']]
var shield_repair_time = Global.shield_repair[Global.upgrade_level['shield_repair']]
var shield_max = Global.shield_max
var shield_level = Global.shield_level 
var max_vel = Global.player_max_vel
var deceleration = Global.player_deceleration_factor
var friction = Global.space_friction
var shoot_counter = 0

#children scenes
export var bullet = preload("res://scenes/player_bullet.tscn")

#spawned nodes
var levelup = preload("res://scenes/effects/level_up.tscn")

#children nodes
onready var bullet_container = get_node("bullet_container")
onready var gun_timer = get_node("gun_timer")
onready var shoot_sounds = get_node("shoot_sounds")
onready var fire = get_node("sounds/fire")
onready var counterclockwise_exhaust_back = get_node("thrusters/counterclockwise_exhaust_back")
onready var counterclockwise_exhaust_front = get_node("thrusters/counterclockwise_exhaust_front")
onready var clockwise_exhaust_back = get_node("thrusters/clockwise_exhaust_back")
onready var clockwise_exhaust_front = get_node("thrusters/clockwise_exhaust_front")
onready var main_exhaust = get_node("thrusters/main_exhaust")
onready var back_exhaust1 = get_node("thrusters/back_exhaust1")
onready var back_exhaust2 = get_node("thrusters/back_exhaust2")

#--------


var screen_size = Vector2()
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2()
var shield_up = true

func _ready():
	Global.resetScores()
	gun_timer.set_wait_time(fire_rate)
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	set_position(pos)
	set_process(true)

#Main game loop
#Calls the player main processes: movement, shoots, shield
func _process(delta):
	vel = vel.clamped(max_vel)
	manageShield(delta)
	setShoots()
	setInputs(delta)
	acc += vel * -friction
	vel += acc * delta
	pos += vel * delta
	setMovements()
	set_position(pos)
	set_rotation(rot - PI/2)

#Manage the cooldown of the player weapon. The fire is continue if the shoot button is pressed, 
func setShoots():
	if Input.is_action_pressed("player_shoot"):
		if gun_timer.get_time_left() == 0:
			shoot()

func manageShield(delta):
	if shield_up :
		shield_level = min(shield_level + shield_regen * delta, shield_max)
		#get_node("shield").show()
		if shield_level <= 0 and shield_up:
			shield_up = false
			shield_level = 0
			get_node("shield").hide()
		if not shield_up:
			emit_signal("shield_down")
			$sounds/shield/shielddown.play()
			$shield_timer.wait_time = shield_repair_time
			$shield_timer.start()

#Manage movements, rotation and the related thrusters effects
func setInputs(delta):
	if Input.is_action_pressed("ui_right"):
		rot += rot_speed * delta
		clockwise_exhaust_back.show()
		clockwise_exhaust_front.show()
	elif Input.is_action_pressed("ui_left"):
		rot -= rot_speed * delta
		counterclockwise_exhaust_back.show()
		counterclockwise_exhaust_front.show()		
	else:
		counterclockwise_exhaust_back.hide()
		counterclockwise_exhaust_front.hide()
		clockwise_exhaust_back.hide()
		clockwise_exhaust_front.hide()
		
	if Input.is_action_pressed("ui_up"):
		acc = Vector2(-thrust, 0).rotated(rot)
		main_exhaust.show()
	elif Input.is_action_pressed("ui_down"):
		vel.x = lerp(vel.x, 0, deceleration)
		vel.y = lerp(vel.y, 0, deceleration)
		back_exhaust1.show()
		back_exhaust2.show()
	else:
		acc = Vector2(0, 0)
		main_exhaust.hide()
		back_exhaust1.hide()
		back_exhaust2.hide()

#Manage movements outside the screen
func setMovements():
	if pos.x > screen_size.x:
		pos.x = 0
	if pos.x < 0:
		pos.x = screen_size.x
	if pos.y > screen_size.y:
		pos.y = 0
	if pos.y < 0:
		pos.y = screen_size.y

#Manage the single weapon shoot
func shoot():
	Global.player_shoot_counter += 1
	gun_timer.start()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(get_rotation() - PI, get_node("muzzle").get_global_position())
	fire.get_child(randi() % (2)).play()

#stops the player ship processes and hides it
func disable():
	hide()
	set_process(false)
	call_deferred("set_enable_monitoring", false)

#gestisce l'evento body entered per i vari oggetti e gruppi, gli eventuali danni
#alcuni oggetti possono essere inviati al metodo anzichè provenire da un segnale per esempio i proiettili nemici che sono anch'essi delle aree2d
func _on_player_body_entered(body):
	print("object entered in player area")
	if !is_visible():
		print("is not visible")
		return
	if body.get_groups().has("asteroids"):
		if shield_up:
			body.explode(vel)
			$sounds/shield/shieldhit.play()
			shield_level -= Global.asteroid_properties[body.size].damage
		else:
			#emit_signal("explode")
			explode()
	if body.is_in_group("enemy_bullet"):
		if shield_up:
			$sounds/shield/shieldhit.play()
			shield_level -= Global.enemy_bullet_damage
		else:
			#emit_signal("explode")
			explode()
	if body.get_groups().has("powerups"):
		if !is_visible():
			return
		if body.is_in_group("powerups"):
			collectPowerup(body)

func explode():
	$sounds/explosion.play()
	print ("hits and shoots")
	print(Global.hits)
	print(Global.player_shoot_counter)
	var accuracy:float = 0.0
	if Global.player_shoot_counter > 0:
		accuracy = (float(Global.hits)/float(Global.player_shoot_counter))*100
	print(accuracy)
	disable()
	emit_signal("explode", accuracy)

#Manage the collecting of powerups
func collectPowerup(body):
	#print("collected ",body.type)
	Global.powerup_counter[body.type] += 1
	emit_signal("pickup", body)
	pickup()
	checkUpgrades(body.type)
	
#manage when player pickups something
func pickup():
	$sounds/pickup.play()

#manage the upgrade system
func checkUpgrades(type):
	#print("check upgrade ", type)
	if Global.powerups_blocked == true:
		return
	match type:
		"gold":
			print("found upgrade gold")
			print(Global.powerup_counter.gold)
			var new_fire_rate:int = Global.powerup_counter.gold/Global.gouge_divider.gold
			
			Global.score += Global.powerup_points.gold
			if new_fire_rate < 5 and fire_rate != Global.fire_rate[new_fire_rate]:
				#print("upgrade fire rate")
				emit_signal("upgrade", "fire rate")
				fire_rate = Global.fire_rate[new_fire_rate]
				gun_timer.set_wait_time(fire_rate)
				levelUp()
			pass
		"silver":
			print("found upgrade silver")
			print(Global.powerup_counter.silver)
			var new_thrust:int = Global.powerup_counter.silver/Global.gouge_divider.silver

			Global.score += Global.powerup_points.silver
			if new_thrust < 5 and thrust != Global.thrust[new_thrust]:
				#print("upgrade thruster")
				emit_signal("upgrade", "thrusters")
				thrust = Global.thrust[new_thrust]
				levelUp()
			pass
		"bronze":
			print("found upgrade bronze")
			print(Global.powerup_counter.bronze)			
			var new_rot_speed:int = Global.powerup_counter.bronze/Global.gouge_divider.bronze


			Global.score += Global.powerup_points.bronze
			if new_rot_speed < 5 and rot_speed != Global.rot[new_rot_speed]:
				emit_signal("upgrade", "rotation")
				rot_speed = Global.rot[new_rot_speed]
				levelUp()
			pass
	print(Global.powerup_counter)

#Manage the upgrade effects
func levelUp():
	var l = levelup.instance()
	$sounds/levelup.play()
	add_child(l)

#Shield repaired event
func _on_shield_timer_timeout():
	$sounds/shield/shieldup.play()
	shield_up = true
	shield_level = 1
