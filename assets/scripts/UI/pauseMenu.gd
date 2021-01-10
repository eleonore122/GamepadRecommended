extends Control

signal options_opened

onready var btn_continue = $PanelContainer/VBoxContainer/btn_continue
onready var btn_options = $PanelContainer/VBoxContainer/btn_options
onready var btn_mainMenu = $PanelContainer/VBoxContainer/btn_MainMenu
onready var btn_quit = $PanelContainer/VBoxContainer/btn_Quit
onready var quit_confirm = $ConfirmationDialog
onready var menu_confirm = $menu_confirm

var main_menu_path = "res://assets/scenes/UI/MainMenu.tscn"
var can_close = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	btn_continue.connect("pressed", self, "close_menu")
	btn_options.connect("pressed", self, "open_options")
	btn_mainMenu.connect("pressed", self, "confirm_mainMenu")
	btn_quit.connect("pressed", self, "quit_confirmation")
	btn_continue.grab_focus()
	$Timer.start()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		close_menu()

func close_menu():
	if can_close:
		queue_free()
		get_tree().paused = false
		get_parent().get_parent().get_node("Node2D").get_node("pause_cd").start()


func quit_confirmation():
	quit_confirm.popup_centered()

func confirm_mainMenu():
	menu_confirm.popup_centered()

func _on_ConfirmationDialog_confirmed():
	get_tree().quit()


func _on_menu_confirm_confirmed():
	LoadManager.load_scene(main_menu_path)

func open_options():
	$optionsPanel.show()
	emit_signal("options_opened")


func _on_optionsPanel_panel_closed():
	btn_options.grab_focus()


func _on_Timer_timeout():
	can_close = true
