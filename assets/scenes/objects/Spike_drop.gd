extends KinematicBody2D


var fallspeed = 500
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.y = fallspeed


func _physics_process(delta):
	velocity = move_and_slide(velocity)
