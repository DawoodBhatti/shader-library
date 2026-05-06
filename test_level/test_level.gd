extends Node

@onready var debug : Node = $Debug

func _ready() -> void:
	
	_setup_window()
	_setup_input_actions()
	
	#print all nodes in scene
	print()
	print("Nodes in scene: ")
	debug.print_all_nodes(get_tree().root)
	print()

	#debug sphere at global origin
	debug.spawn_debug_sphere(Vector3(0,0,0), 1.0)
	

func _setup_window():
	var mode := DisplayServer.window_get_mode()
	
	# --- Mode check ---
	if mode == DisplayServer.WINDOW_MODE_WINDOWED:
		print("'Windowed' mode detected.")
		print("Change default mode to 'Maximized' in Project Settings.")

#automatically setup movement so we don't have to define in project settings each time
func _setup_input_actions():
	print("Setting up input actions...")

	# Define your actions and their events
	var actions := {
		"move_left":   [Key.KEY_A, Key.KEY_LEFT],
		"move_right":  [Key.KEY_D, Key.KEY_RIGHT],
		"move_forward":[Key.KEY_W, Key.KEY_UP],
		"move_back":   [Key.KEY_S, Key.KEY_DOWN],
		"jump":        [Key.KEY_SPACE],
		"shift":       [Key.KEY_SHIFT],
	}

	for action_name in actions.keys():
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)

		# Add keyboard events
		for key in actions[action_name]:
			var key_event := InputEventKey.new()
			key_event.physical_keycode = key
			InputMap.action_add_event(action_name, key_event)

	print("Custom input actions added to InputMap.")


const ACTIONS := [
	"move_left",
	"move_right",
	"move_forward",
	"move_back",
	"jump"
]

func _input(event):
	
	#debug switch to see if control inputs are working
	if true:
		return
	
	if event.is_pressed() and not event.is_echo():
		for action in ACTIONS:
			if event.is_action_pressed(action):
				print("Action pressed:", action)
