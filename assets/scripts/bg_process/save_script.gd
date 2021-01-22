extends Node


var save_path = "user://savegame.sav"

var level_started = ""

var level_paths = {
	"tut_level" : "res://assets/scenes/levels/tutorial_level.tscn",
	"level_one" : "res://assets/scenes/levels/level_one.tscn",
	"level_two" : "res://assets/scenes/levels/level_two.tscn",
	"level_three" : "res://assets/scenes/levels/level_three.tscn",
	"level_four" : "res://assets/scenes/levels/level_four.tscn"
}


func save_game(level_began):
	#set recently completed level for saving completion flags
	level_started = level_began
	
	#set up data to be saved
	var save_dict = {"last_level_started" : level_started}
	
	#save to file
	var save_game = File.new()
	save_game.open(save_path, File.WRITE)
	save_game.store_line(to_json(save_dict))
	
	#close file because yeah
	save_game.close()

func load_save():
	var save_game = File.new()
	if not save_game.file_exists(save_path):
		return #no file to load, shouldn't happen really
	
	#get save data
	save_game.open(save_path, File.READ)
	while save_game.get_position() < save_game.get_len():
		var save_data = parse_json(save_game.get_line())
		level_started = save_data["last_level_started"]
	save_game.close()
	continue_game()

func continue_game():
	if level_paths.has(level_started):
		var level_to_load = level_paths.get(level_started)
		LoadManager.load_scene(level_to_load)
