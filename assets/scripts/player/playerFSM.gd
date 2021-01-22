extends StateMachine

var is_floating = false
var jump_counter = 2
var facing = 1


func _physics_process(_delta):
	if [states.fall].has(state):
		if Input.is_action_pressed("floating") && parent.float_bar.value:
			parent.velocity.y = 0
			parent.floating()
			is_floating = true
	if state == states.floating:
		if Input.is_action_just_pressed("jump") && jump_counter > 0:
			parent.velocity.y = parent.max_jump_velocity
			parent.is_jumping = true
			jump_counter -= 1
			is_floating = false
#		if Input.is_action_just_released("floating") || parent.float_bar.value == 0:
#			is_floating = false

	if state == states.jump:
		if Input.is_action_just_pressed("floating") && parent.float_bar.value > 0:
			parent.velocity.y = 0
			is_floating = true
			parent.floating()
			


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
	call_deferred("set_state", states.idle)

func state_logic(delta):
	parent.get_move_input()
	if !is_floating:
		parent.apply_gravity(delta) 
	parent.apply_movement()

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
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				jump_counter = 2
				parent.float_bar.value = 100
				return states.idle
			elif parent.velocity.y >= 0 && !is_floating:
				return states.fall
			elif is_floating:
				return states.floating
		states.fall:
			if parent.is_on_floor():
				jump_counter = 2
				parent.float_bar.value = 100
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
			if is_floating:
				return states.floating
		states.floating:
			if parent.is_on_floor():
				parent.float_bar.value = 100
				is_floating = false
				jump_counter = 2
				return states.idle
			elif parent.velocity.y >= 0 && !is_floating:
				return states.fall
			elif parent.is_jumping:
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
