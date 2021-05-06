extends Control


# Declare member variables here. Examples:
onready var btn_menu = $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/btn_menu
onready var btn_quit = $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/btn_quit


# Called when the node enters the scene tree for the first time.
func _ready():
	SaveScript.demo_complete = true
	btn_menu.connect("pressed", self, "return_to_menu")
	btn_quit.connect("pressed", self, "quit_game")
	
	btn_menu.grab_focus()


func return_to_menu():
	SaveScript.save_game("tut_level")
	LoadManager.load_scene("res://assets/scenes/UI/MainMenu.tscn")

func quit_game():
	SaveScript.save_game("tut_level")
	get_tree().quit()
