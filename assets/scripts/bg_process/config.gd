extends Node


var windowMode = "fullscreen"
var vsync = true


# Called when the node enters the scene tree for the first time.
func _ready():
	load_from_disk()
	apply_settings()


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

func save_to_disk():
	var config = ConfigFile.new()
	config.set_value("display", "windowMode", windowMode)
	config.set_value("display", "vsync", vsync)
	config.save("user://settings.cfg")

func load_from_disk():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK: #check if file exists
		windowMode = config.get_value("display", "windowMode", "fullscreen")
		vsync = config.get_value("display", "vsync", true) 
