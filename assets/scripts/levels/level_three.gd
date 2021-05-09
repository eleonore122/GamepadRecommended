extends Node2D


signal level_complete

onready var win_timer = $win_timer

var player
var winPanel_scene : PackedScene

var death_count = 0
var tower_death = 0
var time_elapsed = 0.00

var player_scene : PackedScene
var next_level_scene = "res://assets/scenes/levels/level_four.tscn"
var preceeding_levels = 4

# Declare member variables here. Examples:
var camera_limits = {
	"top" : 0,
	"left" : 0,
	"right" : 2113,
	"bottom" : 6240
}

var spawn_point = Vector2(90, 6175)

#comment controls
var tower_comment_seen = false

func _ready():
	player_scene = load("res://assets/scenes/player/player_scene.tscn") as PackedScene
	player = $player
	SaveScript.save_game("level three")
	LoadManager.queue_scene(next_level_scene)

func _physics_process(delta):
	time_elapsed += delta

func respawn_player():
	player.queue_free()
	var new_player = player_scene.instance()
	add_child(new_player)
	player = new_player
	death_count += 1
	if tower_comment_seen:
		tower_death += 1
	label_change()
	

func _on_win_zone_body_entered(body):
	if body == player:
		$comments/winLabel.show()
		emit_signal("level_complete")
		win_timer.start()

func _on_win_timer_timeout():
	winPanel_scene = load("res://assets/scenes/UI/winPanel.tscn") as PackedScene
	var win_panel = winPanel_scene.instance()
	add_child(win_panel)
	win_panel.set_text("Level Three", String(time_elapsed), String(death_count))
	if SaveScript.started_levels.size() <= preceeding_levels:
		SaveScript.started_levels = {
			"tutorial" : "res://assets/gra/level_screencaps/tut_level.png",
			"level one" : "res://assets/gra/level_screencaps/level_1.png",
			"level two" : "res://assets/gra/level_screencaps/level_2.png",
			"level three" : "res://assets/gra/level_screencaps/level_3.png",
			"level four" : "res://assets/gra/level_screencaps/level_4.png"
			}
		SaveScript.save_game("level four")


func load_next_level():
	LoadManager.get_queue_scene(next_level_scene)

func back_to_menu():
	LoadManager.load_scene("res://assets/scenes/UI/MainMenu.tscn")


func _on_checkpoint_body_entered(body):
	if body == player:
		spawn_point = Vector2(1057, 2722)

func label_change():
	if death_count == 1:
		$comments/comment.text = "Just take your time. \nYou've got this"
	if death_count == 2:
		$comments/comment.text = "One more time"
	if tower_comment_seen:
		$comments/comment4.text = "Do you like towers? \nI like towers"
	if tower_comment_seen && tower_death >= 4:
		$comments/comment4.text = "Kinda getting tired of this tower now"
	if spawn_point == Vector2(1057, 2722) && tower_death > 0:
		$comments/comment5.text = "Think it through for a moment. \nTake a deep breath. \n And give it one more shot."
	
	
	
	
	
	
	

func _on_tower_comment_seen_body_entered(body):
	if body == player:
		tower_comment_seen = true
