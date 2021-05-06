extends Control


# Declare member variables here. Examples:
onready var grid = $PanelContainer/VBoxContainer/GridContainer
onready var btn_menu = $PanelContainer/VBoxContainer/HBoxContainer/Button

var temp_object : PackedScene
var level_select_object_path = "res://assets/scenes/UI/level_select_object.tscn"

var player_levels_resource_path

var levels = {}
var temp_levels = {}
var screenshot_paths = {}



# Called when the node enters the scene tree for the first time.
func _ready():
	player_levels_resource_path = SaveScript.current_character_resource_path
	var player_levels_resource = load(player_levels_resource_path)
	temp_levels = player_levels_resource.set_temp_levels()
	screenshot_paths = player_levels_resource.screenshot_paths
	var tmp = 0
	var keys = SaveScript.started_levels.keys()
	for x in keys:
		if temp_levels.has(x):
			temp_levels[x] = SaveScript.started_levels[x]
		
	btn_menu.connect("pressed", self, "return_to_menu")
	btn_menu.grab_focus()
	keys = temp_levels.keys()
	for x in temp_levels:
		if temp_levels[x] != null:
			temp_object = load(level_select_object_path) as PackedScene
			var new_level_select = temp_object.instance()
			new_level_select.level_name = keys[tmp]
			new_level_select.image_path = screenshot_paths[keys[tmp]]
			grid.add_child(new_level_select)
			tmp += 1
		
func return_to_menu():
	LoadManager.load_scene("res://assets/scenes/UI/MainMenu.tscn")

