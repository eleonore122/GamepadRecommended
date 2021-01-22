extends Control

signal options_opened

onready var btn_continue = $PanelContainer/VBoxContainer/Control/VBoxContainer/btn_Continue
onready var btn_NewGame = $PanelContainer/VBoxContainer/Control/VBoxContainer/btn_NewGame
onready var btn_Options = $PanelContainer/VBoxContainer/Control/VBoxContainer/btn_Options
onready var btn_Quit = $PanelContainer/VBoxContainer/Control/VBoxContainer/btn_Quit

onready var quit_confirm = $ConfirmationDialog
onready var option_panel = $optionsPanel
onready var windowMode_drop = $optionsPanel/options_page/HBoxContainer/buttons/windowMode
onready var vsync_drop = $optionsPanel/options_page/HBoxContainer/buttons/vsync

var save_exists = false
var tutorial_path = "res://assets/scenes/levels/tutorial_level.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	var save_game = File.new()
	if save_game.file_exists(SaveScript.save_path):
		save_exists = true
	save_game.close()
	#shows continue button if a save exists. saves cannot exist yet.
	if save_exists:
		btn_continue.show()
	#connect buttons so they can call a function
	btn_continue.connect("pressed", self, "load_save")
	btn_NewGame.connect("pressed", self, "start_NewGame")
	btn_Options.connect("pressed", self, "open_options")
	btn_Quit.connect("pressed", self, "quit_confirmation")
	btn_NewGame.grab_focus()


func load_save():
	SaveScript.load_save()


func start_NewGame():
	LoadManager.load_scene(tutorial_path)

#brings a confirmation window for quitting
func quit_confirmation():
	quit_confirm.popup_centered()

func _on_ConfirmationDialog_confirmed():
	get_tree().quit()

func open_options():
	option_panel.show()
	emit_signal("options_opened")




func _on_optionsPanel_panel_closed():
	btn_Options.grab_focus()
