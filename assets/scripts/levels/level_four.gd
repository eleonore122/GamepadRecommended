extends Node2D


signal level_complete

onready var win_timer = $win_timer

var player
var winPanel_scene : PackedScene

var death_count = 0
var time_elapsed = 0.00

var player_scene : PackedScene
var next_level_scene = "res://assets/scenes/levels/level_five.tscn" #change to level 5 after demo is released
var preceeding_levels = 4

var saw_spawn = Vector2(-100, 0)

#label controls
var in_drop_area = true

# Declare member variables here. Examples:
var camera_limits = {
	"top" : -1000,
	"left" : 0,
	"right" : 13696,
	"bottom" : 1080
}

var spawn_point = Vector2(400, 976)

func _ready():
	player_scene = load("res://assets/scenes/player/player_scene.tscn") as PackedScene
	player = $player
	SaveScript.save_game("level four")

func _physics_process(delta):
	time_elapsed += delta

func respawn_player():
	label_change()
	player.queue_free()
	var new_player = player_scene.instance()
	add_child(new_player)
	player = new_player
	death_count += 1
	$saw_wall.position = saw_spawn
	#delete arrows already launched
	var launchers = $"arrow launchers".get_children()
	for j in launchers:
		var arrows = j.get_children()
		for x in arrows:
			if x is KinematicBody2D:
				x.queue_free()

func _on_win_zone_body_entered(body):
	if body == player:
		$comments/winLabel.show()
		emit_signal("level_complete")
		win_timer.start()

func _on_win_timer_timeout():
	winPanel_scene = load("res://assets/scenes/UI/winPanel.tscn") as PackedScene
	var win_panel = winPanel_scene.instance()
	add_child(win_panel)
	win_panel.set_text("Level Four", String(time_elapsed), String(death_count))
	if SaveScript.started_levels.size() <= preceeding_levels:
		SaveScript.started_levels = {
		"tutorial" : "res://assets/gra/level_screencaps/tut_level.png",
		"level one" : "res://assets/gra/level_screencaps/level_1.png",
		"level two" : "res://assets/gra/level_screencaps/level_2.png",
		"level three" : "res://assets/gra/level_screencaps/level_3.png",
		"level four" : "res://assets/gra/level_screencaps/level_4.png",
		"level five" : "res://assets/gra/level_screencaps/level_5.PNG"
		}


func load_next_level():
	LoadManager.load_scene(next_level_scene)

func back_to_menu():
	SaveScript.save_game("tutorial")
	LoadManager.load_scene("res://assets/scenes/UI/MainMenu.tscn")


func _on_checkpoint_body_entered(body):
	if body == player:
		spawn_point = Vector2(8772, 222)
		saw_spawn = Vector2(8200,0)


func _on_column_label_seen_body_entered(body):
	if body == player:
		$comments/comment3.text = "You've got this!"

func label_change():
	if death_count == 1:
		$comments/comment.text = "Give it your best shot!"
		$comments/comment2.text = "Careful this time"
	if in_drop_area:
		$comments/comment4.text = "I told you to be careful. Try again."


func _on_drop_label_area_body_entered(body):
	if body == player:
		in_drop_area = true


func _on_drop_label_area_body_exited(body):
	if body == player:
		in_drop_area = false

