extends Node

enum ACTIONS {jump, floating, time_slow, move_left, move_right}

#display options
var windowMode = "fullscreen"
var vsync = true
var action_scancodes = {
	"jump" : 32,
	"floating" : 74,
	"time_slow" : 76,
	"move_left" : 65,
	"move_right" : 68
}

var InputType = "gamepad"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_from_disk()
	apply_settings()
	apply_scancodes()

func _input(event):
	if event is InputEventKey:
		InputType = "keyboard"
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		InputType = "gamepad"

func apply_settings():
	#set windowMode
	if windowMode == "fullscreen":
		OS.window_fullscreen = true
	if windowMode == "windowed":
		OS.window_fullscreen = false
	
	#set vsync mode
	if vsync == true:
		OS.vsync_enabled = true
	else:
		OS.vsync_enabled = false
		
	save_to_disk()


func save_keybinds(action_to_save, device_type):
	#get scancode from new input
	var input_map = InputMap.get_action_list(action_to_save)
	if device_type == "keyboard":
		for i in input_map:
			if i is InputEventKey:
				var scancode = i.get_scancode()
				print(scancode)
				action_scancodes[action_to_save] = scancode
		save_to_disk()
	
func apply_scancodes():
	for i in ACTIONS:
		var input_map = InputMap.get_action_list(i)
		for j in input_map:
			if j is InputEventKey:
				j.set_scancode(action_scancodes[i])


func save_to_disk():
	var config = ConfigFile.new()
	config.set_value("display", "windowMode", windowMode)
	config.set_value("display", "vsync", vsync)
	config.save("user://settings.cfg")
	var keybind_file = File.new()
	keybind_file.open("user://keybinds.hf", File.WRITE)
	keybind_file.store_line(to_json(action_scancodes))
	keybind_file.close()

func load_from_disk():
	#load user settings
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK: #check if file exists
		windowMode = config.get_value("display", "windowMode", "fullscreen")
		vsync = config.get_value("display", "vsync", true) 
	#load keybinds
	var keybind_file = File.new()
	if not keybind_file.file_exists("user://keybinds.hf"):
		return #error out because this file don't exist
	keybind_file.open("user://keybinds.hf", File.READ)
	var data = parse_json(keybind_file.get_as_text())
	keybind_file.close()
	if typeof(data) == TYPE_DICTIONARY:
		action_scancodes = data
	else:
		print("error loading keybinds")
