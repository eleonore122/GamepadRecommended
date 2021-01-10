extends Control


onready var level_name_label = $CanvasLayer/PanelContainer/VBoxContainer/level_name
onready var time_label = $CanvasLayer/PanelContainer/VBoxContainer/time_elapsed
onready var death_label = $CanvasLayer/PanelContainer/VBoxContainer/deathCount

onready var btn_nextLevel = $CanvasLayer/PanelContainer/VBoxContainer/buttons/btn_nextLevel
onready var btn_backToMenu = $CanvasLayer/PanelContainer/VBoxContainer/buttons/btn_backToMenu

var parent

func _ready():
	btn_nextLevel.connect("pressed", self, "load_next_level")
	btn_backToMenu.connect("pressed", self, "back_to_menu")
	parent = get_parent()
	get_tree().paused = true
	
	

func set_text(level_name_text, time_text, deathCount_text):
	level_name_label.text = level_name_text
	time_label.text = "Time Elapsed(in seconds) = " + time_text
	death_label.text = "Number of Deaths = " + deathCount_text
	show()

func back_to_menu():
	parent.back_to_menu()

func load_next_level():
	parent.load_next_level()
