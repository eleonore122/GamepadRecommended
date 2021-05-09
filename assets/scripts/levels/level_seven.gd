extends Node2D


signal level_complete

onready var win_timer = $win_timer

var player
var winPanel_scene : PackedScene

var death_count = 0
var time_elapsed = 0.00

var player_scene : PackedScene
var next_level_scene = "res://assets/scenes/levels/tutorial_level.tscn" #next level to load

var preceeding_levels = 8

#set camera limits
var camera_limits = {
	"top" : 0,
	"left" : 0,
	"right" : 14590,
	"bottom" : 1085
}

var spawn_point = Vector2(112, 976) #set where the player should spawn

func _ready():
	SaveScript.current_character_resource_path = "res://assets/level_select_resources/player_1.tres"
	player_scene = load("res://assets/scenes/player/player_scene.tscn") as PackedScene
	player = $player
	SaveScript.save_game("level_seven") #set to current level
	LoadManager.queue_scene(next_level_scene)

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
	var launchers = $"arrow_launchers".get_children()
	for j in launchers:
		var arrows = j.get_children()
		for x in arrows:
			if x is KinematicBody2D:
				x.queue_free()
	var ball_launchers = $ball_launchers.get_children()
	for i in ball_launchers:
		var balls = i.get_children()
		for v in balls:
			if v is RigidBody2D:
				v.queue_free()
	var moving_platforms = $moving_platforms.get_children()
	for k in moving_platforms:
		if k.position != k.move_points[0]:
			k.tween.stop_all()
			k.position = k.move_points[0]

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
	win_panel.set_text("Level Seven", String(time_elapsed), String(death_count)) #set first argument to current level
	if SaveScript.started_levels.size() <= preceeding_levels: #check if completed levels needs to be overwritten
		SaveScript.started_levels = {"tutorial" : "res://assets/gra/level_screencaps/tut_level.png",
		"level one" : "res://assets/gra/level_screencaps/level_1.png",
		"level two" : "res://assets/gra/level_screencaps/level_2.png",
		"level three" : "res://assets/gra/level_screencaps/level_3.png",
		"level four" : "res://assets/gra/level_screencaps/level_4.png",
		"level five" : "res://assets/gra/level_screencaps/level_5.PNG",
		"level six" : "res://assets/gra/level_screencaps/level_6.png",
		"level seven" : "res://assets/gra/level_screencaps/level_7.png"} #set to completed levels
		SaveScript.save_game("level seven")

#called from the win panel
func load_next_level():
	LoadManager.get_queue_scene(next_level_scene)

#called from the win panel
func back_to_menu():
	LoadManager.load_scene("res://assets/scenes/UI/MainMenu.tscn")

func label_change():
	pass #function used to change comments after player dies, or whenever really. can be called during other events.


func _on_checkpoint_body_entered(body):
	if body == player:
		spawn_point = Vector2(7425, 250)
