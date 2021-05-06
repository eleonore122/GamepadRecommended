extends KinematicBody2D


# Declare member variables here. Examples:
var arrow_speed = 64 * 4.8 #5 tiles/second
var arrow_direction = 1 #default to right
var velocity = Vector2()

var collision_direction = Vector2()

func _ready():
	var parent = get_parent()
	arrow_direction = parent.launch_direction
	position = parent.spawn_point.position

func _physics_process(_delta):
	#remember to write code for arrow direction
	collision_direction.x = arrow_direction
	#arrow movement
	velocity.x = arrow_speed * arrow_direction
	velocity.y = 0
	velocity = move_and_slide(velocity)
	
	#collision detection
	var collision = move_and_collide(collision_direction)
	if collision:
		handle_collision(collision)

func handle_collision(node):
	var collider = node.get_collider()
	if collider is TileMap || collider.is_in_group("dangers") || collider.is_in_group("moving_platform"):
		queue_free()
