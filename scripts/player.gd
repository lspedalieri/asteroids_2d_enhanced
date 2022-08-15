extends Area2D

signal explode
signal pickup

var rot_speed = Global.rot_level[Global.upgrade_level['rot']]
var thrust = Global.thrust_level[Global.upgrade_level['thrust']]
var max_vel = 400
var friction = 0.05
export var bullet = preload("res://scenes/player_bullet.tscn")
onready var bullet_container = get_node("bullet_container")
onready var gun_timer = get_node("gun_timer")
onready var shoot_sounds = get_node("shoot_sounds")
onready var fire = get_node("sounds/fire")

var screen_size = Vector2()
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2()
var shield_level = Global.shield_max / 2
var shield_up = true

func _ready():
	gun_timer.set_wait_time(Global.fire_level[Global.upgrade_level['fire_rate']])
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	set_position(pos)
	set_process(true)

#Main game loop
func _process(delta):
	setShield(delta)
	setShoots()
	setInputs(delta)
	acc += vel * -friction
	vel += acc * delta
	pos += vel * delta
	setMovements()
	set_position(pos)
	set_rotation(rot - PI/2)

func setShoots():
	if Input.is_action_pressed("player_shoot"):
		if gun_timer.get_time_left() == 0:
			shoot()

func setShield(delta):
	if shield_up :
		shield_level = min(shield_level + Global.shield_level[Global.upgrade_level['shield_regen']] * delta, Global.shield_max)
		if shield_level <= 0 and shield_up:
			shield_up = false
			shield_level = 0
			get_node("shield").hide()


func setInputs(delta):
	if Input.is_action_pressed("ui_right"):
		rot += rot_speed * delta
	if Input.is_action_pressed("ui_left"):
		rot -= rot_speed * delta
	if Input.is_action_pressed("ui_up"):
		acc = Vector2(-thrust, 0).rotated(rot)
		get_node("exhaust").show()
		
	else:
		acc = Vector2(0, 0)
		get_node("exhaust").hide()

func setMovements():
	if pos.x > screen_size.x:
		pos.x = 0
	if pos.x < 0:
		pos.x = screen_size.x
	if pos.y > screen_size.y:
		pos.y = 0
	if pos.y < 0:
		pos.y = screen_size.y

func shoot():
	gun_timer.start()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(get_rotation() - PI, get_node("muzzle").get_global_position())
	fire.get_child(randi() % (2)).play()
	
func disable():
	hide()
	set_process(false)
	call_deferred("set_enable_monitoring", false)

func damage(amount):
	if shield_up:
		shield_level -= amount
	else:
		disable()
		emit_signal("explode")

#gestisce l'evento body entered per i vari oggetti e gruppi
func _on_player_body_entered(body):
	if body.get_groups().has("asteroids"):
		if !is_visible():
			return
		if body.is_in_group("asteroids"):
			if shield_up:
				body.explode(vel)
				damage(Global.ast_damage[body.size])
	if body.get_groups().has("powerups"):
		if !is_visible():
			return
		if body.is_in_group("powerups"):
			print("collect powerup")
			collectPowerup(body)
			
func collectPowerup(body):
	#print("body ",body)
	emit_signal("pickup", body)
