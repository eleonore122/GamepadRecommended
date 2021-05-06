extends Control


# Declare member variables here. Examples:
onready var image = $VBoxContainer/TextureButton
onready var label = $VBoxContainer/Label

var image_path = ""
var level_name = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	set_image()
	set_LevelName()
	image.connect("pressed", self, "load_level")


func set_image():
	image.texture_normal = load(image_path)

func set_LevelName():
	label.text = level_name

func load_level():
	var level_to_load = SaveScript.level_paths[level_name]
	LoadManager.load_scene(level_to_load)

func _on_TextureButton_focus_entered():
	$Panel/pointer.show()


func _on_TextureButton_focus_exited():
	$Panel/pointer.hide()
