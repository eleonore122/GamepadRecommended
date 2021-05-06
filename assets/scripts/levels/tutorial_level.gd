extends Node2D

enum ACTIONS {jump, floating, time_slow, move_left, move_right}

signal level_complete

onready var win_timer = $win_timer
onready var jump_label = $tut_labels/intro2
onready var float_label = $tut_labels/large_gap2
onready var time_label = $tut_labels/time_slow3

var preceeding_levels = 0

var player

var player_scene : PackedScene
var next_level_scene = "res://assets/scenes/levels/level_one.tscn"

var winPanel_scene : PackedScene

var death_count = 0
var time_elapsed = 0.00

var pad_btn_dict = {
	0 : "X",
	1 : "Circle",
	2 : "Square",
	3 : "Triangle",
	4 : "Left Bumper",
	5 : "Right Bumper",
	6 : "Left Trigger",
	7 : "Right Trigger",
	8 : "Left Stick Click",
	9 : "Right Stick CLick",
	10 : "Select",
	11 : "Start",
	12 : "Dpad Up",
	13 : "Dpad Down",
	14 : "Dpad Left",
	15 : "Dpad Right" 
}

var jump_input_string  = "Space"
var floating_input_string = "J"
var time_slow_input_string = "L"

# Declare member variables here. Examples:
var camera_limits = {
	"top" : 0,
	"left" : 0,
	"right" : 5888,
	"bottom" : 1080
}

var spawn_point = Vector2(100, 990)


func _ready():
	player_scene = load("res://assets/scenes/player/player_scene.tscn") as PackedScene
	
	player = $player
	if SaveScript.started_levels.size() <= preceeding_levels: #check if completed levels needs to be overwritten
		SaveScript.started_levels = {"tutorial" : "res://assets/gra/level_screencaps/level_1.png"}
	SaveScript.save_game("tutorial")

func respawn_player():
	player.queue_free()
	var new_player = player_scene.instance()
	add_child(new_player)
	player = new_player
	death_count += 1

func _physics_process(delta):
	time_elapsed += delta


func _on_win_zone_body_entered(body):
	if body == player:
		$tut_labels/winLabel.show()
		emit_signal("level_complete")
		win_timer.start()


func _on_win_timer_timeout():
	winPanel_scene = load("res://assets/scenes/UI/winPanel.tscn") as PackedScene
	var win_panel = winPanel_scene.instance()
	add_child(win_panel)
	win_panel.set_text("Tutorial", String(time_elapsed), String(death_count))
	if SaveScript.started_levels.size() <= preceeding_levels:
		SaveScript.started_levels = {
		"tutorial" : "res://assets/gra/level_screencaps/tut_level.png",
		"level one" : "res://assets/gra/level_screencaps/level_1.png"
			}


func load_next_level():
	LoadManager.load_scene(next_level_scene)
	
func back_to_menu():
	SaveScript.save_game("level one")
	LoadManager.load_scene("res://assets/scenes/UI/MainMenu.tscn")

func _input(event: InputEvent):
		if event is InputEventKey:
			for i in ACTIONS:
				if i == "jump":
					var input_map = InputMap.get_action_list(i)
					for x in input_map:
						if x is InputEventKey:
							jump_input_string = x.as_text()
				elif i == "floating":
					var input_map = InputMap.get_action_list(i)
					for x in input_map:
						if x is InputEventKey:
							floating_input_string = x.as_text()
				if i == "time_slow":
					var input_map = InputMap.get_action_list(i)
					for x in input_map:
						if x is InputEventKey:
							time_slow_input_string = x.as_text()
			jump_label.text = "Press " + jump_input_string + " to Jump!"
			float_label.text = "Press " + floating_input_string + " to float across safely"
			time_label.text = "Press " + time_slow_input_string + " to slow things down"
		
		elif event is InputEventJoypadButton || InputEventJoypadMotion:
			for i in ACTIONS:
				if i == "jump":
					var input_map = InputMap.get_action_list(i)
					for x in input_map:
						if x is InputEventJoypadButton:
							if pad_btn_dict.has(x.button_index):
								jump_input_string = pad_btn_dict[x.button_index]
				elif i == "floating":
					var input_map = InputMap.get_action_list(i)
					for x in input_map:
						if x is InputEventJoypadButton:
							if pad_btn_dict.has(x.button_index):
								floating_input_string = pad_btn_dict[x.button_index]
				if i == "time_slow":
					var input_map = InputMap.get_action_list(i)
					for x in input_map:
						if x is InputEventJoypadButton:
							if pad_btn_dict.has(x.button_index):
								time_slow_input_string = pad_btn_dict[x.button_index]
			jump_label.text = "Press " + jump_input_string + " to Jump!"
			float_label.text = "Press " + floating_input_string + " to float across safely"
			time_label.text = "Press " + time_slow_input_string + " to slow things down"
