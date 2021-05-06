extends Node2D

enum ACTIONS {jump, floating, time_slow, move_left, move_right}

signal level_complete

onready var win_timer = $win_timer
onready var jump_label = $Control/jump_label2
onready var float_label = $Control/float_label2
onready var time_label = $Control/time_label2

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

var player
var winPanel_scene : PackedScene

var death_count = 0
var time_elapsed = 0.00

var player_scene : PackedScene
var next_level_scene = "res://assets/scenes/UI/demo_end.tscn" #next level to load

var preceeding_levels = 0

var jump_input_string  = "Space"
var floating_input_string = "J"
var time_slow_input_string = "L"

#set camera limits
var camera_limits = {
	"top" : 0,
	"left" : 0,
	"right" : 7865,
	"bottom" : 1960
}

var spawn_point = Vector2(93, 1885) #set where the player should spawn

func _ready():
	player_scene = load("res://assets/scenes/player/player_2_scene.tscn") as PackedScene
	player = $player
	if SaveScript.started_levels.size() <= preceeding_levels: #check if completed levels needs to be overwritten
		SaveScript.started_levels = {"tutorial" : "res://assets/gra/level_screencaps/player_2/tut_level.png"} #set to completed levels
	SaveScript.save_game("tutorial") #set to current level


#records how long you've played a level
func _physics_process(delta):
	time_elapsed += delta

func respawn_player():
	label_change()
	player.queue_free()
	var new_player = player_scene.instance()
	add_child(new_player)
	player = new_player
	death_count += 1
	#delete arrows already launched
	#uncomment if you have arrows or balls
	var launchers = $"arrow_launchers".get_children()
	for j in launchers:
		var arrows = j.get_children()
		for x in arrows:
			if x is KinematicBody2D:
				x.queue_free()
#	var ball_launchers = $ball_launchers.get_children()
#	for i in launchers:
#		var balls = i.get_children()
#		for v in balls:
#			if v is RigidBody2D:
#				v.queue_free()

func _on_win_zone_body_entered(body):
	if body == player:
		$Label.show()
		emit_signal("level_complete")
		win_timer.start()

#creates a win panel scene as a child of the current scene, and initiates the text to reflect level name, how long the player played this level, and how many times the player died
func _on_win_timer_timeout():
	winPanel_scene = load("res://assets/scenes/UI/winPanel.tscn") as PackedScene
	var win_panel = winPanel_scene.instance()
	add_child(win_panel)
	win_panel.set_text("template", String(time_elapsed), String(death_count)) #set first argument to current level
	if SaveScript.started_levels.size() < preceeding_levels: #check if completed levels needs to be overwritten
		SaveScript.started_levels = {"tutorial" : "res://assets/gra/level_screencaps/player_2/tut_level.png"} #set to completed levels
	

#called from the win panel
func load_next_level():
	LoadManager.load_scene(next_level_scene)

#called from the win panel
func back_to_menu():
	SaveScript.save_game("tut_level") #save level as completed before returning to the menu
	LoadManager.load_scene("res://assets/scenes/UI/MainMenu.tscn")

func label_change():
	pass #function used to change comments after player dies, or whenever really. can be called during other events.
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
			float_label.text = "Press " + floating_input_string + " to float in the air, and \nuse the left stick to pick a direction to dash"
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
			float_label.text = "Press " + floating_input_string + " to float in the air, and \nuse the left stick to pick a direction to dash"
			time_label.text = "Press " + time_slow_input_string + " to slow things down"

