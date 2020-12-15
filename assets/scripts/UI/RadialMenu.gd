extends Control


# Declare member variables here. Examples:
onready var power_1 = $circle/zero/power_btn
onready var power_2 = $circle/one/power_btn
onready var power_3 = $circle/two/power_btn
onready var power_4 = $circle/three/power_btn


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	var deadzone = 0.1
	if event is InputEventJoypadMotion:
		var direction = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_0),
		Input.get_joy_axis(0, JOY_AXIS_1)
	)
		if abs(direction.x) < deadzone:
			direction.x = 0
		if abs(direction.y) < deadzone:
			direction.y = 0
		if direction.y >= 0:
			direction.y = 0
		var angle = direction.angle()
		
		if direction.y == 0:
			power_1.pressed = false
			power_2.pressed = false
			power_3.pressed = false
			power_4.pressed = false
		else:
			gamepad_radial(angle)

func gamepad_radial(angle):
	power_1.pressed = false
	power_2.pressed = false
	power_3.pressed = false
	power_4.pressed = false
	
	if angle >= -1.5 && angle <= -0.6:
		if power_1.pressed == false:
			power_1.pressed = true
			power_2.pressed = false
			power_3.pressed = false
			power_4.pressed = false
	elif angle <= -.6 && angle >= -2.6:
		if power_3.pressed == false:
			power_1.pressed = false
			power_2.pressed = false
			power_3.pressed = true
			power_4.pressed = false
	elif angle >= -3 && angle <= -2.6:
		if power_4.pressed == false:
			power_1.pressed = false
			power_2.pressed = false
			power_3.pressed = false
			power_4.pressed = true
	elif angle <= 2.6 && angle >= -0.6:
		if power_2.pressed == false:
			power_1.pressed = false
			power_2.pressed = true
			power_3.pressed = false
			power_4.pressed = false
	else:
		power_1.pressed = false
		power_2.pressed = false
		power_3.pressed = false
		power_4.pressed = false

