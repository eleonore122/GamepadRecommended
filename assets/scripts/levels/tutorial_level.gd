extends Node2D

signal level_complete

onready var win_timer = $win_timer
onready var jump_label = $tut_labels/intro
onready var float_label = $tut_labels/large_gap
onready var time_label = $tut_labels/time_slow

var player

var player_scene : PackedScene
var next_level_scene = "res://assets/scenes/levels/level_one.tscn"

var winPanel_scene : PackedScene

var death_count = 0
var time_elapsed = 0.00


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
	SaveScript.save_game("tut_level")

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
	SaveScript.save_game("level_one")
	LoadManager.load_scene("res://assets/scenes/UI/MainMenu.tscn")

func _input(event: InputEvent):
	if death_count == 0:
		if event is InputEventKey:
			jump_label.text = "Hi There! You're a little man on an Adventure! \n \nPress Space to Jump!"
			float_label.text = "Uh Oh! Watch out for the spikes and arrows! \n \nPress J to float across safely"
			time_label.text = "Things are looking pretty sticky... \nI would take my time, \nand think about how to get through \n \nPress L to slow things down"
		
		elif event is InputEventJoypadButton || InputEventJoypadMotion:
			jump_label.text = "Hi There! You're a little man on an Adventure! \n \nPress X to Jump!"
			float_label.text = "Uh Oh! Watch out for the spikes and arrows! \n \nPress R1 to float across safely"
			time_label.text = "Things are looking pretty sticky... \nI would take my time, \nand think about how to get through \n \nPress L1 to slow things down"
	if death_count > 0:
		if event is InputEventKey:
			jump_label.text = "Oh Dear!! Well you'll just have to try again. \n \n And remember to Jump!"
			float_label.text = "Uh Oh! Watch out for the spikes and arrows! \n \nPress J to float across safely"
			time_label.text = "Things are looking pretty sticky... \nI would take my time, \nand think about how to get through \n \nPress L to slow things down"
		
		elif event is InputEventJoypadButton || InputEventJoypadMotion:
			jump_label.text = "Oh Dear!! Well you'll just have to try again. \n \n And remember to Jump!"
			float_label.text = "Uh Oh! Watch out for the spikes and arrows! \n \nPress R1 to float across safely"
			time_label.text = "Things are looking pretty sticky... \nI would take my time, \nand think about how to get through \n \nPress L1 to slow things down"
