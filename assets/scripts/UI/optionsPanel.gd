extends Panel

signal panel_closed
enum ACTIONS {jump, floating, time_slow, move_left, move_right}

#normal stuff buttons
onready var optionPage = $options_page
onready var btn_save = $options_page/save_options
onready var btn_close = $options_page/close_options
onready var windowMode_drop = $options_page/HBoxContainer/buttons/windowMode
onready var vsync_drop = $options_page/HBoxContainer/buttons/vsync

#Input page buttons
onready var inputPage = $Input_page
onready var btn_inputClose = $Input_page/input_close
onready var btn_inputs = $btn_Inputs
onready var btn_keyJump = $Input_page/VBoxContainer/controls/keyboard/jump
onready var btn_key_float = $Input_page/VBoxContainer/controls/keyboard/floating
onready var btn_key_slow = $Input_page/VBoxContainer/controls/keyboard/time_slow
onready var btn_keyLeft = $Input_page/VBoxContainer/controls/keyboard/move_left
onready var btn_keyRight = $Input_page/VBoxContainer/controls/keyboard/move_right

onready var btn_padJump = $Input_page/VBoxContainer/controls/gamepad/jump
onready var btn_padFloat = $Input_page/VBoxContainer/controls/gamepad/floating
onready var btn_padSlow = $Input_page/VBoxContainer/controls/gamepad/time_slow

onready var rebind_popup = $Input_page/rebind_popup
var can_rebind = false
var action_string = ""
var rebind_device = ""

var pad_btn_dict = {
	0 : "X",
	1 : "Circle",
	2 : "Square",
	3 : "Triangle",
	4 : "Left Bumper",
	5 : "Right Bumper",
	6 : "Left Trigger",
	7 : "Right Trigger",
	8 : "Left Stick Click",
	9 : "Right Stick CLick",
	10 : "Select",
	11 : "Start",
	12 : "Dpad Up",
	13 : "Dpad Down",
	14 : "Dpad Left",
	15 : "Dpad Right",
	16 : "Misc. SDL",
	17 : "",
	18 : "",
	19 : "",
	20 : "",
	21 : "touchpad"
}




# Called when the node enters the scene tree for the first time.
func _ready():
	btn_save.connect("pressed", self, "save_options")
	btn_close.connect("pressed", self, "close_options")
	btn_inputs.connect("pressed", self, "open_inputPage")
	btn_inputClose.connect("pressed", self, "close_inputPage")
	btn_padJump.connect("pressed", self, "gamepad_jump")
	btn_padFloat.connect("pressed", self, "gamepad_floating")
	btn_padSlow.connect("pressed", self, "gamepad_time_slow")

func init_options():
	if Config.windowMode == "fullscreen":
		windowMode_drop.selected = 0
	else:
		windowMode_drop.selected = 1
	if Config.vsync == true:
		vsync_drop.selected = 0
	else:
		vsync_drop.selected = 1

func save_options():
	if windowMode_drop.selected == 0:
		Config.windowMode = "fullscreen"
	else:
		Config.windowMode = "windowed"
	
	if vsync_drop.selected == 0:
		Config.vsync = true
	else:
		 Config.vsync = false
	
	Config.apply_settings()

func close_options():
	hide()
	emit_signal("panel_closed")


func _on_MainMenu_options_opened():
	init_options()
	btn_save.grab_focus()


func _on_pauseMenu_options_opened():
	init_options()
	btn_save.grab_focus()

func open_inputPage():
	btn_inputs.hide()
	optionPage.hide()
	inputPage.show()
	init_keyboard_text()
	init_gamepad_text()
	btn_inputClose.grab_focus()

func close_inputPage():
	btn_inputs.show()
	optionPage.show()
	inputPage.hide()
	btn_save.grab_focus()

func rebind_action(action_to_bind, device_type):
	get_tree().paused = true
	#custom keybinds currently not allowed for gamepad. work on that later i guess
	if !InputMap.get_action_list(action_string).empty():
		#check if new key is already assigned to another action, and erase if so
		for i in ACTIONS:
			if InputMap.action_has_event(i, action_to_bind):
				InputMap.action_erase_event(i, action_to_bind)
		
		#erase old keybind
		var action_to_rebind = InputMap.get_action_list(action_string)
		if device_type == "keyboard":
			for i in action_to_rebind:
				if i is InputEventKey:
					InputMap.action_erase_event(action_string, i)
		if device_type == "gamepad":
			for i in action_to_rebind:
				if i is InputEventJoypadButton:
					InputMap.action_erase_event(action_string, i)
		#add new keybind
		InputMap.action_add_event(action_string, action_to_bind)
		if device_type == "keyboard":
			set_keyboard_text()
		elif device_type == "gamepad":
			set_gamepad_text()
		
		if action_string != null:
			Config.save_keybinds(action_string, device_type)
		rebind_popup.hide()
		$UI_timer.start()

func init_keyboard_text():
	var keyboardButtons = $Input_page/VBoxContainer/controls/keyboard.get_children()
	for i in ACTIONS:
		for j in keyboardButtons:
			if j.get_name() == i:
				var input_map = InputMap.get_action_list(i)
				for x in input_map:
					if x is InputEventKey:
						j.set_text(x.as_text())
func init_gamepad_text():
	var gamepadButtons = $Input_page/VBoxContainer/controls/gamepad.get_children()
	for i in ACTIONS:
		for j in gamepadButtons:
			if j.get_name() == i:
				var input_map = InputMap.get_action_list(i)
				for x in input_map:
					if x is InputEventJoypadButton:
						if pad_btn_dict.has(x.button_index):
							j.set_text(pad_btn_dict[x.button_index])

func set_keyboard_text():
	var keyboardButtons = $Input_page/VBoxContainer/controls/keyboard.get_children()
	for i in keyboardButtons:
		if i.get_name() == action_string:
			#check which event has a keyboard input
			var input_map = InputMap.get_action_list(action_string)
			for j in input_map:
				if j is InputEventKey:
					i.set_text(j.as_text())

func set_gamepad_text():
	var gamepadButtons = $Input_page/VBoxContainer/controls/gamepad.get_children()
	for i in gamepadButtons:
		if i.get_name() == action_string:
			#check which event has a keyboard input
			var input_map = InputMap.get_action_list(action_string)
			for j in input_map:
				if j is InputEventJoypadButton:
					if pad_btn_dict.has(j.button_index):
						i.set_text(pad_btn_dict[j.button_index])

func _input(event):
	if can_rebind == true:
		if rebind_device == "keyboard":
			if event is InputEventKey:
				can_rebind = false
				rebind_action(event, "keyboard")
		if rebind_device == "gamepad":
			if event is InputEventJoypadButton:
				can_rebind = false
				rebind_action(event, "gamepad")

func _on_jump_pressed():
	rebind_popup.window_title = "Keyboard Jump"
	can_rebind = true
	action_string = "jump"
	rebind_popup.popup_centered()
	rebind_device = "keyboard"

func _on_floating_pressed():
	rebind_popup.window_title = "Keyboard Floating"
	can_rebind = true
	action_string = "floating"
	rebind_popup.popup_centered()
	rebind_device = "keyboard"


func _on_time_slow_pressed():
	rebind_popup.window_title = "Keyboard Time Slow"
	can_rebind = true
	action_string = "time_slow"
	rebind_popup.popup_centered()
	rebind_device = "keyboard"


func _on_move_left_pressed():
	rebind_popup.window_title = "Keyboard Move Left"
	can_rebind = true
	action_string = "move_left"
	rebind_popup.popup_centered()
	rebind_device = "keyboard"


func _on_move_right_pressed():
	rebind_popup.window_title = "Keyboard Move Right"
	can_rebind = true
	action_string = "move_right"
	rebind_popup.popup_centered()
	rebind_device = "keyboard"

func gamepad_jump():
	rebind_popup.window_title = "Gamepad Jump"
	can_rebind = true
	action_string = "jump"
	rebind_popup.popup_centered()
	rebind_device = "gamepad"

func gamepad_floating():
	rebind_popup.window_title = "Gamepad Floating"
	can_rebind = true
	action_string = "floating"
	rebind_popup.popup_centered()
	rebind_device = "gamepad"

func gamepad_time_slow():
	rebind_popup.window_title = "Gamepad Time Slow"
	can_rebind = true
	action_string = "time_slow"
	rebind_popup.popup_centered()
	rebind_device = "gamepad"
	


func _on_UI_timer_timeout():
	get_tree().paused = false
