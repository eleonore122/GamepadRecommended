extends Node

var current_character_resource_path = ""

var player_1_save_path = "user://player_1_savegame.sav"
var player_2_save_path = "user://player_2_savegame.sav"

var level_started = ""

var demo_complete = false #will control level select availability in the demo. remove after demo release

var started_levels = {}

var level_paths = {}

var temp_levels = {
		"tutorial" : null,
		"level one" : null,
		"level two" : null,
		"level three" : null,
		"level four" : null,
		"level five" : null,
		"level six" : null
		}

func save_game(level_began):
	var save_path = ""
	#check which file to save to
	if current_character_resource_path == "res://assets/level_select_resources/player_1.tres":
		var paths_dict = load(current_character_resource_path)
		save_path = player_1_save_path
		level_paths = paths_dict.level_paths
	else:
		var paths_dict = load(current_character_resource_path)
		save_path = player_2_save_path
		level_paths = paths_dict.level_paths
	#set recently started level to local variable
	level_started = level_began
	
	#set up data to be saved
	var save_dict = {
		"last_level_started" : level_started,
		"demo_complete" : demo_complete,
		"started_levels" : started_levels,
		"level_paths" : level_paths
	}
	
	#save to file
	var save_game = File.new()
	save_game.open(save_path, File.WRITE)
	save_game.store_string(to_json(save_dict))
	
	#close file because yeah
	save_game.close()
func load_save():
	var save_path = ""
	#check which file to save to
	if current_character_resource_path == "res://assets/level_select_resources/player_1.tres":
		save_path = player_1_save_path
	else:
		save_path = player_2_save_path
	var save_game = File.new()
	if not save_game.file_exists(save_path):
		var paths_dict = load(current_character_resource_path)
		level_paths = paths_dict.level_paths
		level_started = "tutorial"
		return
		
	save_game.open(save_path, File.READ)
	while save_game.get_position() < save_game.get_len():
		var save_data = parse_json(save_game.get_line())
		started_levels = save_data["started_levels"]
		level_started = save_data["last_level_started"]
		level_paths = save_data["level_paths"]
	save_game.close()

