##############################################
#
#	Start singleton scene
#	Main variables, object templates, starting methods
#
##############################################

extends Node

#global game settings

var leaderboard_scene = "res://scenes/leaderboard_table.tscn"
var game_scene = "res://scenes/main.tscn"
var game_over = false
var username := ""
var leaderboard_score = {}
var score = 0
var chrono = 0
var level = 0
var paused = false
var current_scene = null
var new_scene = null
var leaderboard_data = [{
	"accuracy": 0,
	"date":1704715200,
	"name":"Orloph",
	"score":1000,
	"time":1000
},
{
	"accuracy": 0,
	"date":1704715200,
	"name":"Orloph",
	"score":1000,
	"time":1000
},
{
	"accuracy": 0,
	"date":1704715200,
	"name":"Orloph",
	"score":1000,
	"time":1000
},
{
	"accuracy": 0,
	"date":1704715200,
	"name":"Orloph",
	"score":1000,
	"time":1000
}]


#colors
var light_grey = Color( 0.8, 0.8, 0.8, 1 )
var yellow = Color( 0, 1, 0, 1 )
var red = Color( 1, 0, 0, 1 )
var blue = Color( 0, 0, 1, 1 )
var black = Color( 0, 0, 0, 1 )
var white = Color( 1, 1, 1, 1 )

#space settings
var space_friction = 0.05
var background

#tricks: da usare nelle modalità "storia/quest"
var powerups_drop = true
var powerups_get = true

#HUD settings
var messages = {'game_over': 'Game Over'}

#player settings
var shield_max = 100
var shield_level = 50
var player_max_vel = 300
var player_deceleration_factor = 0.05
var bullet_damage = 10
var cash = 0
var player_shoot_counter = 0
var hits = 0
var powerups_blocked = false
var upgrade_level = {
	'thrust':0,
	'fire_rate':0,
	'rot':0,
	'manouver':1,
	'shield_regen':0,
	'shield_repair':0,
	'damage':10,
	'shield':50
}
var fire_rate = {0:0.5, 1:0.4, 2:0.3, 3:0.2, 4:0.1}
var thrust = {0:100, 1:200, 2:400, 3:600, 4:800}
var rot = {0:1, 1:1.5, 2:2.5, 3:3.5, 4:4.5}
var shield_regen = {0:2.5, 1:5, 2:7.5, 3:10, 4:15}
var shield_repair = {0:20, 1:15, 2:10, 3:5, 4:3}
#var shield_max = {0:100, 1:150, 2:200, 3:300, 4:400}
var powerup_counter_template = {
	"gold":0, 	#fire rate upgrade
	"silver":0, #thruster upgrade
	"bronze":0 	#rotation upgrade
}

var powerup_counter = {
	"gold":0, 	#fire rate upgrade
	"silver":0, #thruster upgrade
	"bronze":0 	#rotation upgrade
}

var gouge_divider = {
	'bronze':5,
	'silver':5,
	'gold':5,
	} 

#asteroid settings
var spawn_locations_num = 8
var asteroid_max_vel = 300
var explode_distance = 25
var asteroid_sizes = ["big", "med", "sm", "tiny"]
var break_pattern = {'big' : 'med', 'med' : 'sm', 'sm' : 'tiny', 'tiny' : null}
var asteroid_template = {'size':'','life':'','damage':'','points':'','drop_chance':'','texture':'', 'vel':Vector2(0,0), 'pos':Vector2(0,0)}
var asteroid_explosion_sounds = ["res://audio/scifi/explosionCrunch_000.ogg", 
						"res://audio/scifi/explosionCrunch_001.ogg", 
						"res://audio/scifi/explosionCrunch_002.ogg", 
						"res://audio/scifi/explosionCrunch_003.ogg", 
						"res://audio/scifi/explosionCrunch_004.ogg"]
var asteroid_properties = {
	'big' : {'textures': [
						'res://art/asteroids/asteroid-big-1.png',
						'res://art/asteroids/asteroid-big-2.png',
						'res://art/asteroids/asteroid-big-3.png'
					],
			'maps': [
						'res://art/asteroids/asteroid-big-1_n.png',
						'res://art/asteroids/asteroid-big-2_n.png',
						'res://art/asteroids/asteroid-big-3_n.png'
					],
			'sounds':["res://audio/scifi/explosionCrunch_000.ogg", 
						"res://audio/scifi/explosionCrunch_001.ogg", 
						"res://audio/scifi/explosionCrunch_002.ogg", 
						"res://audio/scifi/explosionCrunch_003.ogg", 
						"res://audio/scifi/explosionCrunch_004.ogg"
					],
			 'life': 40,
			 'damage': 40,
			 'points': 10,
			 'drop_chance': 0.5
			},
	'med' : {'textures': [
						'res://art/asteroids/asteroid-med-1.png',
						'res://art/asteroids/asteroid-med-2.png',
						'res://art/asteroids/asteroid-med-3.png'
					],
			'maps': [
						'res://art/asteroids/asteroid-med-1_n.png',
						'res://art/asteroids/asteroid-med-2_n.png',
						'res://art/asteroids/asteroid-med-3_n.png'
					],
			'sounds':["res://audio/scifi/explosionCrunch_000.ogg", 
						"res://audio/scifi/explosionCrunch_001.ogg", 
						"res://audio/scifi/explosionCrunch_002.ogg", 
						"res://audio/scifi/explosionCrunch_003.ogg", 
						"res://audio/scifi/explosionCrunch_004.ogg"
					],
			 'life': 30,
			 'damage': 25,
			 'points': 15,
			 'drop_chance': 0.6
			},
	'sm' : {'textures': [
					   'res://art/asteroids/asteroid-small-1.png',
					   'res://art/asteroids/asteroid-small-2.png',
					   'res://art/asteroids/asteroid-small-3.png'
					],
			'maps': [
					   'res://art/asteroids/asteroid-small-1_n.png',
					   'res://art/asteroids/asteroid-small-2_n.png',
					   'res://art/asteroids/asteroid-small-3_n.png'
					],
			'sounds':["res://audio/scifi/explosionCrunch_000.ogg", 
						"res://audio/scifi/explosionCrunch_001.ogg", 
						"res://audio/scifi/explosionCrunch_002.ogg", 
						"res://audio/scifi/explosionCrunch_003.ogg", 
						"res://audio/scifi/explosionCrunch_004.ogg"
					],
			 'life': 20,
			 'damage': 15,
			 'points': 20,
			 'drop_chance': 0.8
			},
	'tiny' : {'textures': [
					   'res://art/asteroids/asteroid-tiny-1.png',
					   'res://art/asteroids/asteroid-tiny-2.png',
					   'res://art/asteroids/asteroid-tiny-3.png'],
			'maps': [
					   'res://art/asteroids/asteroid-tiny-1_n.png',
					   'res://art/asteroids/asteroid-tiny-2_n.png',
					   'res://art/asteroids/asteroid-tiny-3_n.png'
					],
			'sounds':["res://audio/scifi/explosionCrunch_000.ogg", 
						"res://audio/scifi/explosionCrunch_001.ogg", 
						"res://audio/scifi/explosionCrunch_002.ogg", 
						"res://audio/scifi/explosionCrunch_003.ogg", 
						"res://audio/scifi/explosionCrunch_004.ogg"],
			 'life': 10,
			 'damage': 10,
			 'points': 40,
			 'drop_chance': 0.95
			}
}

#enemy settings
var enemy_timer = 60
var enemy_drop_chance = 0.95
var enemy_bullet_damage = 25
var enemy_health = 30
var enemy_points = 100
var boss_health = 200
var boss_points = 1000

#powerup settings
var powerup_textures = {"bronze":'res://art/powerups/star_bronze.png',
						"silver":'res://art/powerups/star_silver.png',
						"gold":'res://art/powerups/star_gold.png'}
var powerup_points = {"bronze":50, "silver":100, "gold":200}

var powerup_lifetime = 15

#title letters
var letters_path = "res://art/labels/letters/"
var letters = []
var title_coordinates = [
	{"letter" : "A", "start_coords" : Vector2(120, 200), "end_coords" : Vector2(120, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "S", "start_coords" : Vector2(180, 200), "end_coords" : Vector2(180, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "T", "start_coords" : Vector2(240, 200), "end_coords" : Vector2(240, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "E", "start_coords" : Vector2(300, 200), "end_coords" : Vector2(300, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "R", "start_coords" : Vector2(360, 200), "end_coords" : Vector2(360, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "O", "start_coords" : Vector2(420, 200), "end_coords" : Vector2(420, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "I", "start_coords" : Vector2(460, 200), "end_coords" : Vector2(460, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "D", "start_coords" : Vector2(500, 200), "end_coords" : Vector2(500, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "S", "start_coords" : Vector2(560, 200), "end_coords" : Vector2(560, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "O", "start_coords" : Vector2(680, 200), "end_coords" : Vector2(680, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "N", "start_coords" : Vector2(740, 200), "end_coords" : Vector2(740, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "S", "start_coords" : Vector2(860, 200), "end_coords" : Vector2(860, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "T", "start_coords" : Vector2(920, 200), "end_coords" : Vector2(920, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "E", "start_coords" : Vector2(980, 200), "end_coords" : Vector2(980, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "R", "start_coords" : Vector2(1040, 200), "end_coords" : Vector2(1040, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "O", "start_coords" : Vector2(1100, 200), "end_coords" : Vector2(1100, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "I", "start_coords" : Vector2(1140, 200), "end_coords" : Vector2(1140, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "D", "start_coords" : Vector2(1180, 200), "end_coords" : Vector2(1180, 165), "method" : "TRANS_SINE", "time" : 3},
	{"letter" : "S", "start_coords" : Vector2(1240, 200), "end_coords" : Vector2(1240, 165), "method" : "TRANS_SINE", "time" : 3},
]


#########################################################
#
#	Global Singleton Methods to start and restart game
#
#########################################################

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	var s = ResourceLoader.load(path)
	var new_scene = s.instance()
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	print(current_scene)
	current_scene.queue_free()
	current_scene = new_scene

#Opening in start screen
func leaderboard():
	print("leaderboard")
	print(powerup_counter)
	print(powerup_counter_template)
	game_over = false
	resetScores()
	print("resetted scores")
	print(powerup_counter)
	print(powerup_counter_template)
	goto_scene(leaderboard_scene)
	#SceneTransition.change_scene(leaderboard_scene)

func new_game():
	print("new game")
	resetScores()
	goto_scene(game_scene)
	#SceneTransition.change_scene(game_scene)

func resetScores():
	score = 0
	level = 0
	powerup_counter = {
		"gold":0, 	#fire rate upgrade
		"silver":0, #thruster upgrade
		"bronze":0 	#rotation upgrade
	}

	#powerup_counter = powerup_counter_template

func preloadLetters(font):
	var dir = Directory.new()
	dir.open(letters_path + font + "/")
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			#break the while loop when get_next() returns ""
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
			letters.append(load(letters_path + "/" + file_name))
	dir.list_dir_end()
	print(letters)
	
