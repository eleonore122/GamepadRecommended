extends Node2D


# Declare member variables here. Examples:
# var a = 2
var speed = 4.5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	self.position.x += speed
	if Engine.time_scale == 0.5:
		speed = 2.25
	else:
		speed = 4.5
	
