extends KinematicBody2D

# Declare member variables here. Examples:
export var move_points = [Vector2(), Vector2()]
export var vert = false
export var tween_time : int
var started = false
var player_entered
export var one_way = false

onready var tween = $Tween

var current_position = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	current_position = position
	tween.interpolate_property(self, "position", current_position, move_points[1], tween_time, Tween.TRANS_LINEAR)
	if vert:
		vertical_sprite()

func _physics_process(_delta):
	if !started && player_entered:
		current_position = position
		position_check()
		start_check()
	if started && !tween.is_active():
		started = false

func vertical_sprite():
	var vertical_texture = load("res://assets/gra/obj/V_moving_platform_sign.png")
	$Sprite.texture = vertical_texture

func start_check():
	if player_entered == true:
		started = true
		tween.start()


func _on_Tween_tween_all_completed():
	started = false
	current_position = position
	position_check()

func position_check():
	if position == move_points[1] && !one_way:
		tween.interpolate_property(self, "position", current_position, move_points[0], tween_time, Tween.TRANS_LINEAR)
	elif position == move_points[0]:
		tween.interpolate_property(self, "position", current_position, move_points[1], tween_time, Tween.TRANS_LINEAR)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		player_entered = true



func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		player_entered = false
