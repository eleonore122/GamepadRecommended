extends Node2D


# Declare member variables here. Examples:
onready var launch_timer = $ball_CD
var ball : PackedScene
onready var spawn_point = $ball_spawn

var launch_direction = 1 #default to right
 
# Called when the node enters the scene tree for the first time.
func _ready():
	ball = load("res://assets/scenes/objects/ball.tscn") as PackedScene
	
	if scale.x == -1:
		launch_direction = -1
	launch_timer.start()


func _on_ball_CD_timeout():
	var new_ball = ball.instance()
	add_child(new_ball)
	launch_timer.start()
