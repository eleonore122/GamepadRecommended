extends KinematicBody2D

signal grounded_updated

const UP = Vector2(0, -1)

onready var dangers
onready var scene
onready var state_label = $state_label
onready var dash_end = $dash_end
onready var coyote_timer = $Node2D/coyote_timer
onready var camera = $Camera2D
onready var animation_sprite = $AnimatedSprite
onready var FSM_node = $Node2D
onready var time_bar = $timeBar
onready var time_bar_hide = $time_bar_hide
onready var time_slow_cooldown = $time_slow_cooldown
onready var tween = $Tween

var pauseMenu : PackedScene
var can_pause = true
onready var pause_cd = $Node2D/pause_cd

var move_speed = 5 * 64 #64 is the tile size
var V_dash_speed = 15 * 64
var H_dash_speed = 20 * 64

var max_jump_velocity
var min_jump_velocity
var max_jump_height = (3.35 * 64)
var min_jump_height = (0.8 * 64)
var jump_duration = 0.5
var gravity

var is_grounded = false
var is_jumping = false
var can_jump = true
var is_dead = false
var is_dashing = false
var time_slowed = false

var velocity = Vector2()
var pointer_vector = Vector2()
var dash_counter = 2
var dash_radius = 1.6



# Called when the node enters the scene tree for the first time.
func _ready():
	
	dangers = get_parent().get_node("dangers")
	scene = get_parent()
	pauseMenu = load("res://assets/scenes/UI/pauseMenu.tscn")

	
	camera.limit_right = scene.camera_limits.right
	camera.limit_top = scene.camera_limits.top
	camera.limit_bottom = scene.camera_limits.bottom
	camera.limit_left = scene.camera_limits.left
	
	#set collision data for respawning
	set_collision_mask_bit(1, true)
	set_safe_margin(0.004)
	
	#set spawn point
	position = scene.spawn_point
	
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)


func _physics_process(_delta):
	$Dash_counter.text = String(dash_counter)
	var collision = move_and_collide(Vector2(0, 1), true, true, true)
	var collision_ceiling = move_and_collide(Vector2(0, -1), true, true, true)
	if collision && !is_dead:
		death_collision(collision)
	elif collision_ceiling && !is_dead:
		death_collision(collision_ceiling)
		
	if !coyote_timer.is_stopped() && Input.is_action_just_pressed("jump"):
		jump()
	
	if Input.is_action_just_pressed("pause") && can_pause:
		pause_menu()
	update_facing()

	if dash_counter > 0 && is_dashing:
		if Input.is_action_pressed("floating") && Config.InputType == "gamepad":
			gamepad_dash()
		if Input.is_action_pressed("floating") && Config.InputType == "keyboard":
			keyboard_dash()
		
			#store angle for dash if vector.x does not equal 0
	if Input.is_action_just_released("floating") && pointer_vector.x != 0 || pointer_vector.y != 0 && Input.is_action_just_released("floating"):
		var dash_velocity = Vector2(0,0)
		dash_velocity.x = pointer_vector.x * H_dash_speed
		dash_velocity.y = pointer_vector.y * V_dash_speed
		velocity = move_and_slide(dash_velocity)
		pointer_vector = Vector2()
		dash_counter -= 1
	
	if !is_dashing:
		$dash_pointer.hide()
		$dash_pointer.rotation_degrees = 0
	
	if Input.is_action_pressed("time_slow") && time_bar.value > 0:
		time_bar.modulate.a = 1
		Engine.set_time_scale(0.3)
		time_slowed = true
		time_bar.value -= 0.25
	if Input.is_action_just_released("time_slow") || time_bar.value == 0 && time_slowed:
		time_bar_hide.start()
		time_slowed = false
		time_slow_cooldown.start()
		Engine.set_time_scale(1)


func pause_menu():
	var pause_panel = pauseMenu.instance()
	can_pause = false
	$pause_layer.add_child(pause_panel)



func apply_gravity(delta):
	velocity.y += gravity * delta
	#set is_jumping to false when the player starts moving downwards after jumping
	if is_jumping && velocity.y > 0:
		is_jumping = false


	
func apply_movement():

	#set is_jumping to false if the player is jumping and moves downwards
	if is_jumping && velocity.y >= 0:
		is_jumping = false

	#snap to floor if not jumping
	var snap = Vector2.DOWN * 32 if !is_jumping else Vector2.ZERO
	
	#move the player
	velocity = move_and_slide_with_snap(velocity, snap, UP)
	
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_updated")

func apply_dash_movement():
	velocity = move_and_slide(velocity)


func get_move_input():
	#gets running inputs. has analog stick support through get_action_strength
	if !is_dashing:
		var move_direction = -float(Input.get_action_strength("move_left")) + float(Input.get_action_strength("move_right"))
		velocity.x = move_speed * move_direction


func update_facing():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	if move_direction == -1:
		$AnimatedSprite.flip_h = true
	elif move_direction == 1:
		$AnimatedSprite.flip_h = false

func jump():
	if is_on_floor() || !coyote_timer.is_stopped():
		velocity.y = max_jump_velocity
		is_jumping = true

func floating():
	velocity = Vector2()
	is_dashing = true

func death_collision(node):
	var collider = node.get_collider()
	if collider == dangers:
		is_dead = true
		death()

func death():
	is_dead = false
	FSM_node.is_floating = false
	scene.respawn_player()


func _on_KinematicBody2D_grounded_updated():
	if !is_on_floor() && !is_jumping:
		velocity.y = 0
		coyote_timer.start()
		FSM_node.is_floating = true

#reset gravity to normal when you leave coyote time
func _on_coyote_timer_timeout():
	FSM_node.is_floating = false


func _on_danger_detect_body_entered(body):
	if body.is_in_group("dangers"):
		is_dead = true
		scene.call_deferred("respawn_player")


func _on_pause_cd_timeout():
	can_pause = true


func _on_dash_end_timeout():
	is_dashing = false
	FSM_node.is_floating = false

func gamepad_dash():
	#show dash pointer, get angle of left stick, and rotate the arrow to match it
	$dash_pointer.show()
	pointer_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	pointer_vector.y = Input.get_action_strength("analog_down") - Input.get_action_strength("analog_up")
	
	pointer_vector = pointer_vector.normalized()
	pointer_vector -= pointer_vector * dash_radius
	pointer_vector = -pointer_vector
	$dash_pointer.rotation_degrees = rad2deg(pointer_vector.angle_to_point(Vector2(0,0)))
	$angle_label.text = String(rad2deg(pointer_vector.angle_to_point(Vector2(0,0))))



func keyboard_dash():
	$dash_pointer.show()
	pointer_vector = get_local_mouse_position().normalized()
	pointer_vector -= pointer_vector * dash_radius
	pointer_vector = -pointer_vector
	$dash_pointer.rotation_degrees = rad2deg(pointer_vector.angle_to_point(Vector2(0,0)))


func _on_time_bar_hide_timeout():
	tween_hide_resource(time_bar)

func _on_time_slow_cooldown_timeout():
	if !time_slowed:
		time_bar.value = 100

func tween_hide_resource(bar):
	if bar == time_bar:
		if !time_slowed:
			tween.interpolate_property(bar, "modulate", Color.white ,Color.transparent, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
