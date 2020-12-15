extends Node2D


# Declare member variables here. Examples:
onready var launch_timer = $arrow_CD
var arrow : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	arrow = load("res://assets/scenes/objects/arrow.tscn") as PackedScene
	launch_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_arrow_CD_timeout():
	var new_arrow = arrow.instance()
	add_child(new_arrow)
	launch_timer.start()
