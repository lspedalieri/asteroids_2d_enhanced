extends Node

#global game settings

var game_over = false
var score = 0
var level = 0
var paused = false
var current_scene = null
var new_scene = null

#player settings
var shield_max = 100
var player_max_vel = 300
var shield_regen = 10
var bullet_damage = 10
var cash = 0
var upgrade_level = {
	'thrust':1,
	'fire_rate':1,
	'rot':1,
	'manouver':1,
	'shield_regen':4,
	'guns':1,
	'shield':50
}
var thrust_level = {1:200, 2:400, 3:600, 4:800}
var rot_level = {1:1.5, 2:2.5, 3:3.5, 4:4.5}
var shield_level = {1:5, 2:7.5, 3:10, 4:15}
var fire_level = {1:0.4, 2:0.3, 3:0.2, 4:0.1}
var powerup_counter := {
	"gold":0,
	"silver":0,
	"bronze":0
}


#asteroid settings
var asteroid_drop_chance = 0.95
var spawn_locations_num = 8
var asteroid_max_vel = 300
var explode_distance = 25
var asteroid_sizes = ["big", "med", "sm", "tiny"]
var break_pattern = {'big' : 'med', 'med' : 'sm', 'sm' : 'tiny', 'tiny' : null}
var ast_damage = {'big' : 40, 'med' : 25, 'sm' : 15, 'tiny' : 10}
var ast_points = {'big' : 10, 'med' : 15, 'sm' : 20, 'tiny' : 40}
var asteroid_textures = {'big': ['res://art/asteroids/meteorGrey_big1.png',
						'res://art/asteroids/meteorGrey_big3.png',
						'res://art/asteroids/meteorGrey_big4.png'],
				'med': ['res://art/asteroids/meteorGrey_med1.png',
						'res://art/asteroids/meteorGrey_med2.png'],
				'sm': ['res://art/asteroids/meteorGrey_small1.png',
					   'res://art/asteroids/meteorGrey_small2.png'],
				'tiny': ['res://art/asteroids/meteorGrey_tiny1.png',
						 'res://art/asteroids/meteorGrey_tiny2.png']}
						

#enemy settings
var enemy_drop_chance = 0.50
var enemy_bullet_damage = 25
var enemy_health = 30
var enemy_points = 100
var boss_health = 200
var boss_points = 1000

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	var s = ResourceLoader.load(path)
	var new_scene = s.instance()
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	current_scene.queue_free()
	current_scene = new_scene
	
func new_game():
	game_over = false
	score = 0
	level = 0
	goto_scene("res://scenes/main.tscn")
	
#powerup settings
var powerup_textures = {"bronze":'res://art/powerups/star_bronze.png',
						"silver":'res://art/powerups/star_silver.png',
						"gold":'res://art/powerups/star_gold.png'}
						
