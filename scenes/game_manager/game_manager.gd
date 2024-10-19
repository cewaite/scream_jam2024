class_name GameManager extends Node3D

enum GAME_STATE { MAIN_MENU, MENU_TO_PLAY, PLAYING, PAUSED }

@export var room: TheRoom
@export var idle_rot_speed: float = 0.3
@export var return_rot_speed: float = 2.0

@export var camera: Camera3D
@export var seated_camera_marker: Marker3D
@export var camera_speed: float = 1.0

var curr_game_state: GAME_STATE = GAME_STATE.MAIN_MENU
var screen: ComputerScreen
var player_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	screen = room.computer_screen
	SignalController.connect("submit_answer", _on_screen_gui_submit_answer)
	SignalController.connect("pause", _on_screen_gui_pause)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match curr_game_state:
		GAME_STATE.MAIN_MENU:
			room.rotation = lerp(room.rotation, room.rotation + Vector3.UP, delta * idle_rot_speed)
			if rad_to_deg(room.rotation.y) >= 360.0:
				room.rotation.y = 0.0
		GAME_STATE.MENU_TO_PLAY:
			room.rotation = lerp(room.rotation, Vector3.ZERO, delta * return_rot_speed)
			camera.position = lerp(camera.position, seated_camera_marker.position, delta * camera_speed)
			camera.rotation = lerp(camera.rotation, seated_camera_marker.rotation, delta *  camera_speed)
			if vector_is_equal_approx(room.rotation, Vector3.ZERO) and vector_is_equal_approx(camera.position, seated_camera_marker.position) and vector_is_equal_approx(camera.rotation, seated_camera_marker.rotation):
				curr_game_state = GAME_STATE.PLAYING
				play_game()

func play_game():
	# Send intro message from Proctor explaining rules
	send_intro()
	# Loop until Player or Subject has 3 strikes:
	#	Proctor asks question
	#	10 sec timer to answer or Player shocked
	#	Subject answers
	#	If Subject answer != Players, shock Subject
	#	Repeat 
	pass

func send_intro():
	var intro_msgs = [
		"Welcome, Tester...",
		"For this experiment, you will be testing the Subject on a subset of predetermined questions. A mix of multiple choice and mathmatics.",
		"You will be given a limited time to answer each question. Type your answer into the terminal. Press Enter to submit.",
		"Failure to answer within the time interval results in [i]corrective action[/i] taken against [i]you[/i].",
		"The Subject's answer will be displayed on screen and, to ensure accuracy, will be compared to yours.",
		"Subjects failure to answer according to your truth with result in [i]corrective action[/i] against [i]them[/i].",
		"Consent to the conditions of the experiment by submitting your name..."
	]
	for msg in intro_msgs:
		var full_msg = "[b]Proctor:[/b] " + msg
		screen.add_message(full_msg)
		await get_tree().create_timer(5.0).timeout
	screen.screen_gui.toggle_enter_button()

func _on_main_menu_start_game():
	curr_game_state = GAME_STATE.MENU_TO_PLAY

func vector_is_equal_approx(v1 : Vector3, v2 : Vector3):
	return is_equal_approx(v1.x, v2.x) and is_equal_approx(v1.y, v2.y) and is_equal_approx(v1.z, v2.z)

func _on_screen_gui_submit_answer(answer : String):
	# if player_name is null, handle answer as if thats what they're answering,
	# handle question answer otherwise.
	if not player_name:
		if not answer or answer.is_empty():
			screen.add_message("[b]Proctor:[/b] NULL values will not be tolerated. Submit a name.")
		elif answer == "God":
			screen.add_message("[b]Proctor:[/b] God is irrelevant here. Submit a name.")
		else:
			screen.screen_gui.toggle_enter_button()
			await get_tree().create_timer(2.0).timeout
			player_name = answer
			screen.add_message("[b]Proctor:[/b] Very good, " + player_name + ". Begin.")
			await get_tree().create_timer(3.0).timeout
	else:
		screen.add_message("[b]" + player_name + ":[/b]")

func _on_screen_gui_pause():
	pass # Replace with function body.


