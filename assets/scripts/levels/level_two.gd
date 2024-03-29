extends Node2D

signal level_complete

onready var win_timer = $win_timer

var player
var winPanel_scene : PackedScene

var death_count = 0
var time_elapsed = 0.00

var jokeSpotted = false

var player_scene : PackedScene
var next_level_scene = "res://assets/scenes/levels/level_three.tscn"
var preceeding_levels = 3

# Declare member variables here. Examples:
var camera_limits = {
	"top" : 590,
	"left" : 0,
	"right" : 6846,
	"bottom" : 3582
}

var spawn_point = Vector2(100, 975)

var squeeze_joke_seen = false


func _ready():
	player_scene = load("res://assets/scenes/player/player_scene.tscn") as PackedScene
	player = $player
	SaveScript.save_game("level two")
	LoadManager.queue_scene(next_level_scene)

func _physics_process(delta):
	time_elapsed += delta

func respawn_player():
	player.queue_free()
	var new_player = player_scene.instance()
	add_child(new_player)
	player = new_player
	death_count += 1
	label_death_update()

func label_death_update():
	if death_count == 1:
		$commentLabels/Intro.text = "Good luck"
		$commentLabels/Intro2.hide()
		$commentLabels/bad_joke.hide()
		if squeeze_joke_seen == true:
			$commentLabels/squeeze_joke.hide()
	

func _on_win_zone_body_entered(body):
	if body == player:
		$commentLabels/winLabel.show()
		emit_signal("level_complete")
		win_timer.start()


func _on_win_timer_timeout():
	winPanel_scene = load("res://assets/scenes/UI/winPanel.tscn") as PackedScene
	var win_panel = winPanel_scene.instance()
	add_child(win_panel)
	win_panel.set_text("Level Two", String(time_elapsed), String(death_count))
	if SaveScript.started_levels.size() <= preceeding_levels:
		SaveScript.started_levels = {
			"tutorial" : "res://assets/gra/level_screencaps/tut_level.png",
			"level one" : "res://assets/gra/level_screencaps/level_1.png",
			"level two" : "res://assets/gra/level_screencaps/level_2.png",
			"level three" : "res://assets/gra/level_screencaps/level_3.png"
		}
		SaveScript.save_game("level three")

func load_next_level():
	LoadManager.get_queue_scene(next_level_scene)

func back_to_menu():

	LoadManager.load_scene("res://assets/scenes/UI/MainMenu.tscn")

func _on_squeeze_joke_seen_body_entered(body):
	if body == player:
		squeeze_joke_seen = true


func _on_checkpoint_body_entered(body):
	if body == player:
		spawn_point = Vector2(6530,3021)
