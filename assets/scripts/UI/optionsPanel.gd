extends Panel

signal panel_closed

# Declare member variables here. Examples:
onready var btn_save = $save_options
onready var btn_close = $close_options
onready var windowMode_drop = $HBoxContainer/buttons/windowMode
onready var vsync_drop = $HBoxContainer/buttons/vsync





# Called when the node enters the scene tree for the first time.
func _ready():
	btn_save.connect("pressed", self, "save_options")
	btn_close.connect("pressed", self, "close_options")

func init_options():
	if Config.windowMode == "fullscreen":
		windowMode_drop.selected = 0
	else:
		windowMode_drop.selected = 1
	if Config.vsync == true:
		vsync_drop.selected = 0
	else:
		vsync_drop.selected = 1

func save_options():
	#write code to apply options and save them to a config file for the user
	if windowMode_drop.selected == 0:
		Config.windowMode = "fullscreen"
	else:
		Config.windowMode = "windowed"
	
	if vsync_drop.selected == 0:
		Config.vsync = true
	else:
		 Config.vsync = false
	
	Config.apply_settings()

func close_options():
	hide()
	emit_signal("panel_closed")


func _on_MainMenu_options_opened():
	init_options()
	btn_save.grab_focus()


func _on_pauseMenu_options_opened():
	init_options()
	btn_save.grab_focus()
