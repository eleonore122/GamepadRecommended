extends KinematicBody2D


# Declare member variables here. Examples:
var arrow_speed = 64 * 5 #5 tiles/second
var arrow_direction = 1 #default to right
var velocity = Vector2()

var collision_direction = Vector2()


func _physics_process(delta):
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
	if collider is TileMap:
		queue_free()
