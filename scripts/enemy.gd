extends Area2D

signal explode
signal pulse_timeout

var bullet = preload("res://scenes/enemy_bullet.tscn")

onready var paths = get_node("enemy_paths")
onready var bullet_container = get_node("bullet_container")
onready var shoot_timer = get_node("shoot_timer")
onready var enemy_laser = get_node("sounds/enemy_laser")
onready var anim = get_node("anim")

var path
var follow
var remote
var speed = 175
var accuracy = 0.1
var target = null
var health = Global.enemy_health
var pulse_timer

func _ready():
	pulse_timer = Timer.new()
	add_child(pulse_timer)
	pulse_timer.connect("timeout", self, "emit_pulse_timeout")
	add_to_group("enemies")
	set_process(true)
	randomize()
	path = paths.get_children()[randi() % paths.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.set_loop(false)
	remote = Node2D.new()
	follow.add_child(remote)
	shoot_timer.set_wait_time(1.5)	#varia con il livello
	shoot_timer.start()

func _process(delta):
	follow.set_offset(follow.get_offset() + speed * delta)
	set_position(remote.get_global_position())
	if follow.get_unit_offset() > 1:
		queue_free()

func _on_visible_screen_exited():
	queue_free()

#colpo singolo verso il giocatore
func shoot1():
	enemy_laser.play()
	var dir = get_global_position() - target.get_global_position()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(dir.angle() + PI/2, get_global_position())

#colpo multiplo a ventaglio. Il numero di colpi forma automaticamente un cerchio 
func shootCircle(n):
	var dir = get_global_position() - target.get_global_position()
	var rad = 0.0174 * (360/n)
	for a in n:
		var angle = a * rad
		enemy_laser.play()
		var b = bullet.instance()
		bullet_container.add_child(b)
		b.start_at(dir.angle() + angle, get_global_position())


#colpo multiplo a raffica
func shoot_pulse(n, delay):
	for i in range(n):
		shoot1()
		pulse_delay(delay)
		yield(pulse_timer, "timeout")

#fa una selezione casuale del tipo di colpo e ne chiama la funzione
func _on_shoot_timer_timeout():
	if target.is_visible():
		if ((randi() % 5) == 0):
			shoot_pulse(3, 0.1)
		else:
			shoot1()
			shootCircle(rand_range(1, Global.level))

func damage(amount):
	health -= amount
	anim.play("hit")
	if health <= 0:
		Global.score += Global.enemy_points
		emit_signal("explode", get_global_position())
		queue_free()
		
func pulse_delay(delay):
	pulse_timer.set_wait_time(delay)
	pulse_timer.set_timer_process_mode(0)
	pulse_timer.start()
	
func emit_pulse_timeout():
	emit_signal("pulse_timeout")
