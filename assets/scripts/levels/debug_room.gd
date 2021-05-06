extends Node2D


signal level_complete

onready var win_timer = $win_timer

var player
var winPanel_scene : PackedScene

var death_count = 0
var time_elapsed = 0.00

var player_scene : PackedScene
var next_level_scene = "res://assets/scenes/levels/tutorial_level.tscn" #next level to load

var preceeding_levels = 0

#set camera limits
var camera_limits = {
	"top" : -1920,
	"left" : 0,
	"right" : 1920,
	"bottom" : 100
}

var spawn_point = Vector2(90, -35) #set where the player should spawn

func _ready():
	player_scene = load("res://assets/scenes/player/player_2_scene.tscn") as PackedScene
	player = $player
	SaveScript.save_game("level_three") #set to current level

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
	var launchers = $"arrow launchers".get_children()
	for j in launchers:
		var arrows = j.get_children()
		for x in arrows:
			if x is KinematicBody2D:
				x.queue_free()

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
	if SaveScript.completed_levels.size() < preceeding_levels: #check if completed levels needs to be overwritten
		SaveScript.completed_levels = {} #set to completed levels
		var keys = SaveScript.completed_levels.keys()
		for x in keys:
			if SaveScript.temp_levels.has(x):
				SaveScript.temp_levels[x] = SaveScript.completed_levels[x]
	

#called from the win panel
func load_next_level():
	LoadManager.load_scene(next_level_scene)

#called from the win panel
func back_to_menu():
	SaveScript.save_game("tut_level") #save level as completed before returning to the menu
	LoadManager.load_scene("res://assets/scenes/UI/MainMenu.tscn")

func label_change():
	pass #function used to change comments after player dies, or whenever really. can be called during other events.
