extends RigidBody2D

var ball_speed = 64 * 5
var ball_direction = 1

var max_collisions = 4
var collision_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	ball_direction = parent.launch_direction
	position = parent.spawn_point.position
	var velocity = Vector2(ball_speed, 300)
	velocity.x = velocity.x * ball_direction
	apply_central_impulse(velocity)


func _physics_process(_delta):

	var colliding
	colliding = get_colliding_bodies()
	if colliding.size() > 0:
		collision_count += 1
		if collision_count == max_collisions:
			queue_free()
	for x in colliding:
		if x.is_in_group("player"):
			queue_free()
