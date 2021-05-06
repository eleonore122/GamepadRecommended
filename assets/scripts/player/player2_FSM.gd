extends StateMachine

var is_floating = false
var jump_counter = 1
var facing = 1


func _physics_process(_delta):
	if [states.fall, states.jump].has(state):
		if Input.is_action_pressed("floating") && parent.dash_counter > 0:
			parent.velocity.y = 0
			parent.floating()
			is_floating = true
	if state == states.floating:
		if Input.is_action_just_released("floating"):
			parent.dash_end.start()
		


func _input(event):
	#jumping logic
	if [states.idle, states.run].has(state):
		if event.is_action_pressed("jump") && jump_counter > 0:
			if parent.is_on_floor():
				parent.jump()
				jump_counter -= 1

			#smaller jumps here
	if state == states.jump:
		if event.is_action_released("jump") && parent.velocity.y < parent.min_jump_velocity:
			parent.velocity.y = parent.min_jump_velocity
	
func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("floating")
	add_state("dashing")
	call_deferred("set_state", states.idle)

func state_logic(delta):
	if !parent.is_dashing:
		parent.apply_gravity(delta) 
		parent.apply_movement()
		parent.get_move_input()
	else:
		parent.apply_dash_movement()

func get_transition(_delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
			elif is_floating:
				return states.floating
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
			elif is_floating:
				return states.floating
		states.jump:
			if parent.is_on_floor():
				jump_counter = 1
				parent.dash_counter = 2
				return states.idle
			elif parent.velocity.y >= 0 && !is_floating:
				return states.fall
			elif is_floating:
				return states.floating
		states.fall:
			if parent.is_on_floor():
				jump_counter = 1
				parent.dash_counter = 2
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
			if is_floating:
				return states.floating
		states.floating:
			if parent.is_on_floor() && !is_floating:
				is_floating = false
				jump_counter = 1
				parent.dash_counter = 2
				return states.idle
			elif parent.velocity.y >= 0 && !is_floating:
				return states.fall
			elif parent.velocity.y < 0 && !is_floating:
				return states.jump
		
func enter_state(new_state, _old_state):
	if new_state == states.idle:
		parent.state_label.text = "idle"
		parent.animation_sprite.play("idle")
	if new_state == states.run:
		parent.state_label.text = "run"
		parent.animation_sprite.play("idle")
	if new_state == states.fall:
		parent.state_label.text = "fall"
		parent.animation_sprite.play("in_air")
	if new_state == states.jump:
		parent.state_label.text = "jump"
		parent.animation_sprite.play("jump")
	if new_state == states.floating:
		parent.state_label.text = "floating"
		parent.animation_sprite.play("floating")

func exit_state(_old_state, _new_state):
	pass
