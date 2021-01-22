extends Node2D


# Declare member variables here. Examples:
onready var launch_timer = $arrow_CD
var arrow : PackedScene
onready var spawn_point = $arrow_spawn

var launch_direction = 1 #default to right
 
# Called when the node enters the scene tree for the first time.
func _ready():
	arrow = load("res://assets/scenes/objects/arrow.tscn") as PackedScene
	
	if scale.x == -1:
		launch_direction = -1
	launch_timer.start()


func _on_arrow_CD_timeout():
	var new_arrow = arrow.instance()
	add_child(new_arrow)
	launch_timer.start()

