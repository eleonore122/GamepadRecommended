extends Control

signal options_opened

onready var btn_continue = $PanelContainer/VBoxContainer/Control/VBoxContainer/btn_Continue
onready var btn_NewGame = $PanelContainer/VBoxContainer/Control/VBoxContainer/btn_NewGame
onready var btn_LevelSelect = $PanelContainer/VBoxContainer/Control/VBoxContainer/btn_LevelSelect
onready var btn_Options = $PanelContainer/VBoxContainer/Control/VBoxContainer/btn_Options
onready var btn_Quit = $PanelContainer/VBoxContainer/Control/VBoxContainer/btn_Quit

onready var quit_confirm = $ConfirmationDialog
onready var option_panel = $optionsPanel
onready var windowMode_drop = $optionsPanel/options_page/HBoxContainer/buttons/windowMode
onready var vsync_drop = $optionsPanel/options_page/HBoxContainer/buttons/vsync

var save_exists = false
var tutorial_path = "res://assets/scenes/levels/tutorial_level.tscn"
var player_2_tutorial = "res://assets/scenes/levels/player_2/tutorial.tscn"

var character_select_resource_path = "res://assets/level_select_resources/"#directory for finding the resources that contain level scene paths for different characters
var characters = {}
onready var character_select_container = $CharacterSelect/VBoxContainer
onready var player_1_btn = $CharacterSelect/VBoxContainer/player_1
onready var player_2_btn = $CharacterSelect/VBoxContainer/player_2

var last_pressed



# Called when the node enters the scene tree for the first time.
func _ready():
	#dynamically add any character resource paths to a dictionary for character select reasons
	var dir = Directory.new()
	if dir.open(character_select_resource_path) == OK:
		dir.list_dir_begin(true ,false)
		var file_name = dir.get_next()
		while file_name != "": #iterates through the directory until no file is found
			if dir.current_is_dir():
				print("Found Directory:" + file_name)
			else:
				if "tres" in file_name: #might not be necessary, just here in case other stuff goes in there
					var name = file_name.split(".")[0]#takes the file extension off so you only have a character name
					characters[name] = character_select_resource_path + file_name #adds character name to the directory path so you have the actual filepath for loading the resource later
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("an error occurred trying to access that file path")
	var save_game = File.new()
	if save_game.file_exists(SaveScript.player_1_save_path) || save_game.file_exists(SaveScript.player_2_save_path):
		save_exists = true
	save_game.close()
	#shows continue & level select button if a save exists.
	if save_exists:
		btn_continue.show()
		btn_LevelSelect.show()
	#connect buttons so they can call a function
	btn_NewGame.connect("pressed", self, "start_NewGame")
	btn_LevelSelect.connect("pressed", self, "open_character_select")
	btn_continue.connect("pressed", self, "load_save")
	btn_Options.connect("pressed", self, "open_options")
	btn_Quit.connect("pressed", self, "quit_confirmation")
	player_1_btn.connect("pressed", self, "open_player_1_select")
	player_2_btn.connect("pressed", self, "open_player_2_select")
	btn_NewGame.grab_focus()


func load_save():
	open_character_select(btn_continue)


func start_NewGame():
	open_character_select(btn_NewGame)

#brings a confirmation window for quitting
func quit_confirmation():
	quit_confirm.popup_centered()

func _on_ConfirmationDialog_confirmed():
	get_tree().quit()

func open_options():
	option_panel.show()
	emit_signal("options_opened")

func open_level_select():
	LoadManager.load_scene("res://assets/scenes/UI/level_select.tscn")


func _on_optionsPanel_panel_closed():
	btn_Options.grab_focus()

func open_character_select(button_pressed = btn_LevelSelect):
	last_pressed = button_pressed
	player_1_btn.grab_focus()
	$CharacterSelect.show()

func open_player_1_select():
	SaveScript.current_character_resource_path = "res://assets/level_select_resources/player_1.tres"
	if last_pressed == btn_LevelSelect:
		SaveScript.load_save()
		open_level_select()
	if last_pressed == btn_NewGame:
		SaveScript.load_save()
		LoadManager.load_scene(tutorial_path)
	if last_pressed == btn_continue:
		SaveScript.load_save()
		LoadManager.load_scene(SaveScript.level_paths[SaveScript.level_started])

func open_player_2_select():
	SaveScript.current_character_resource_path = "res://assets/level_select_resources/player_2.tres"
	if last_pressed == btn_LevelSelect:
		SaveScript.load_save()
		open_level_select()
	if last_pressed == btn_NewGame:
		LoadManager.load_scene(player_2_tutorial)
	if last_pressed == btn_continue:
		SaveScript.load_save()
		LoadManager.load_scene(SaveScript.level_paths[SaveScript.level_started])


func _on_character_select_close_pressed():
	$CharacterSelect.hide()
	last_pressed.grab_focus()
