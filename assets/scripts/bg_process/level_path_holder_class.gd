class_name LevelPathHolder

export var player_name = ""
export var level_paths = {}
export var screenshot_paths = {}

var temp_levels = {}

func set_temp_levels():
	if player_name == "player 1":
			return {
				"tutorial" : null,
				"level one" : null,
				"level two" : null,
				"level three" : null,
				"level four" : null,
				"level five" : null,
				"level six" : null,
				"level seven" : null
				}
	elif player_name == "player 2": #not implemented yet, only here for testing
		return {
			"tutorial" : null
		}
