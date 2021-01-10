extends Node2D

signal level_complete

onready var win_timer = $win_timer

var player
var winPanel_scene : PackedScene

var death_count = 0
var time_elapsed = 0.00

var jokeSpotted = false

var player_scene : PackedScene
var next_level_scene = "res://assets/scenes/levels/level_two.tscn"

# Declare member variables here. Examples:
var camera_limits = {
	"top" : -64,
	"left" : 0,
	"right" : 3328,
	"bottom" : 2751
}

var spawn_point = Vector2(115, 2633)


func _ready():
	player_scene = load("res://assets/scenes/player/player_scene.tscn") as PackedScene
	
	player = $player
	SaveScript.save_game("level_one")

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
		$commentLabels/intro.text = "Oops. Try again!"
		if jokeSpotted == true:
			$commentLabels/badJoke.hide()
			$commentLabels/arrow_spotted.hide()
	

func _on_win_zone_body_entered(body):
	if body == player:
		$Label.show()
		emit_signal("level_complete")
		win_timer.start()


func _on_win_timer_timeout():
	winPanel_scene = load("res://assets/scenes/UI/winPanel.tscn") as PackedScene
	var win_panel = winPanel_scene.instance()
	add_child(win_panel)
	win_panel.set_text("Tutorial", String(time_elapsed), String(death_count))

func load_next_level():
	LoadManager.load_scene(next_level_scene)

func back_to_menu():
	SaveScript.save_game("level_two")
	LoadManager.load_scene("res://assets/scenes/UI/MainMenu.tscn")


func _on_jokeSpotted_body_entered(body):
	if body == player:
		jokeSpotted = true
