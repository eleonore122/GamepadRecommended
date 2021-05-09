extends Node2D


signal level_complete

onready var win_timer = $win_timer

var player
var winPanel_scene : PackedScene

var death_count = 0
var time_elapsed = 0.00

var player_scene : PackedScene
var next_level_scene = "res://assets/scenes/levels/level_six.tscn" #next level to load
var preceeding_levels = 6

var in_joke_zone = false

#set camera limits
var camera_limits = {
	"top" : 0,
	"left" : 0,
	"right" : 11838,
	"bottom" : 1080
}

var spawn_point = Vector2(96, 975) #set where the player should spawn

func _ready():
	player_scene = load("res://assets/scenes/player/player_scene.tscn") as PackedScene
	player = $player
	SaveScript.save_game("level_five") #set to current level
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
	#delete balls already launched
	var launchers = $ball_launchers.get_children()
	for j in launchers:
		var arrows = j.get_children()
		for x in arrows:
			if x is RigidBody2D:
				x.queue_free()
	launchers = $arrow_launchers.get_children()
	for i in launchers:
		var arrows = i.get_children()
		for x in arrows:
			if x is KinematicBody2D:
				x.queue_free()
	var moving_platforms = $moving_platforms.get_children()
	for k in moving_platforms:
		if k.position != k.move_points[0]:
			k.tween.stop_all()
			k.position = k.move_points[0]

func _on_win_zone_body_entered(body):
	if body == player:
		$comments/winLabel.show()
		emit_signal("level_complete")
		win_timer.start()

#creates a win panel scene as a child of the current scene, and initiates the text to reflect level name, how long the player played this level, and how many times the player died
func _on_win_timer_timeout():
	winPanel_scene = load("res://assets/scenes/UI/winPanel.tscn") as PackedScene
	var win_panel = winPanel_scene.instance()
	add_child(win_panel)
	win_panel.set_text("Level Five", String(time_elapsed), String(death_count)) #set first argument to current level
	if SaveScript.started_levels.size() <= preceeding_levels:
		SaveScript.started_levels = {
		"tutorial" : "res://assets/gra/level_screencaps/tut_level.png",
		"level one" : "res://assets/gra/level_screencaps/level_1.png",
		"level two" : "res://assets/gra/level_screencaps/level_2.png",
		"level three" : "res://assets/gra/level_screencaps/level_3.png",
		"level four" : "res://assets/gra/level_screencaps/level_4.png",
		"level five" : "res://assets/gra/level_screencaps/level_5.PNG",
		"level six" : "res://assets/gra/level_screencaps/level_6.png"
		}
	SaveScript.save_game("level six")

#called from the win panel
func load_next_level():
	LoadManager.get_queue_scene(next_level_scene)

#called from the win panel
func back_to_menu():
	LoadManager.load_scene("res://assets/scenes/UI/MainMenu.tscn")

func label_change():
	if in_joke_zone:
		$comments/joke_choice.text = "Guess you chose wrong."
	pass #function used to change comments after player dies, or whenever really. can be called during other events.


func _on_checkpoint_body_entered(body):
	if body == player:
		spawn_point = Vector2(7612, 200)


func _on_joke_zone_body_entered(body):
	if body == player:
		in_joke_zone = true



func _on_joke_zone_body_exited(body):
	if body == player:
		in_joke_zone = false
