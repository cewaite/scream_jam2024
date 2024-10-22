class_name GameManager extends Node3D

enum GAME_STATE { MAIN_MENU, MENU_TO_PLAY, PLAYING, PAUSED }

const SUBJECT = preload("res://entities/subject/subject.tscn")

@export var room: TheRoom
@export var idle_rot_speed: float = 0.3
@export var return_rot_speed: float = 2.0

@export var camera: Camera3D
@export var seated_camera_marker: Marker3D
@export var hover_camera_marker: Marker3D
@export var camera_speed: float = 1.0

@export var question_timer: Timer
# Higher = more mc, lower = more math
@export var mc_to_math_ratio: float = 0.5
@export var question_until_win: int = 20

@export var ui: UI
@export var transition_screen: TransitionScreen

var curr_game_state: GAME_STATE = GAME_STATE.MAIN_MENU
var screen: ComputerScreen
var player_name: String

var players_strikes: int = 0
var subjects_strikes: int = 0
var bad_answers: int = 0
var curr_question: Question

var total_questions: int = 0
var unanswered_questions: int = 0
var wrong_answers: int = 0

var subject: Subject

# Called when the node enters the scene tree for the first time.
func _ready():
	transition_screen.transition_to_normal()
	screen = room.computer_screen
	SignalController.connect("submit_answer", _on_screen_gui_submit_answer)
	SignalController.connect("pause", _on_screen_gui_pause)
	
	subject = SUBJECT.instantiate()
	add_child(subject)

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
				send_intro()
		
		GAME_STATE.PLAYING:
			screen.screen_gui.timer_label.text = str(question_timer.time_left).pad_decimals(2)

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
	screen.screen_gui.toggle_enter_button()
	if not player_name:
		if not answer or answer.is_empty():
			screen.add_message("[b]Proctor:[/b] NULL values will not be tolerated. Submit a name.")
		elif answer == "God":
			screen.add_message("[b]Proctor:[/b] God is irrelevant here. Submit a name.")
		elif answer == "Proctor" or answer == "Subject":
			screen.add_message("[b]Proctor:[/b] Unavailable. Submit a name.")
		else:
			player_name = answer
			screen.add_message("[b]Proctor:[/b] Very good, " + player_name + ". Begin.")
			await get_tree().create_timer(2.0).timeout
			ask_question()
	else:
		if not answer or answer.is_empty():
			screen.add_message("[b]Proctor:[/b] NULL values will not be tolerated. Submit an answer.")
			handle_bad_answer()
		elif curr_question is MathQuestion and not answer.is_valid_int():
			screen.add_message("[b]Proctor:[/b] Mathmatic's require numerical answer, formatted logically. Try again.")
			handle_bad_answer()
		elif curr_question is MCQuestion and answer != "A" and answer != "B" and answer != "C" and answer != "D" and answer != curr_question.a and answer != curr_question.b and answer != curr_question.c and answer != curr_question.d:
			screen.add_message("[b]Proctor:[/b] An answer of A, B, C, or D is required. Try Again.")
			handle_bad_answer()
		else:
			# Stop Timer
			question_timer.stop()
			# increment total questions answered
			total_questions += 1
			# check if wrong for ending
			if not curr_question.check_answer(answer):
				wrong_answers += 1
			# Show players answer
			screen.add_message("[b]" + player_name + ":[/b] " + answer)
			# Wait then show Subjects answer
			await get_tree().create_timer(2.0).timeout
			var subjects_answer = subject.answer_question(curr_question, subjects_strikes)
			screen.add_message("[b]Subject:[/b] " + subjects_answer)
			await get_tree().create_timer(2.0).timeout
			# Respond accrodingly then move on
			if subjects_answer == answer or (curr_question is MCQuestion and answer == curr_question.get_choice_from_letter(subjects_answer)):
				screen.add_message("[b]Proctor:[/b] Subjects answer concurs with the truth.")
			else:
				screen.add_message("[b]Proctor:[/b] Subjects answer differed from the truth. Administering [i]corrective action[/i].")
				await get_tree().create_timer(2.0).timeout
				strike_subject()
			check_ending_or_cont()
	screen.screen_gui.toggle_enter_button()

func handle_bad_answer():
	bad_answers += 1
	if bad_answers >= 3:
		screen.screen_gui.toggle_enter_button()
		question_timer.stop()
		bad_answers = 0
		await get_tree().create_timer(5.0).timeout
		screen.add_message("[b]Proctor:[/b] Too many bad answers. Disappointing. Administering [i]corrective action[/i].")
		strike_player()
		await get_tree().create_timer(2.0).timeout
		screen.add_message("[b]Proctor:[/b] Next question...")
		ask_question()
		screen.screen_gui.toggle_enter_button()

func check_ending_or_cont():
	if players_strikes == 4:
		end_game_player_lost()
	elif subjects_strikes == 4:
		end_game_subject_lost()
	elif total_questions < question_until_win:
		await get_tree().create_timer(2.0).timeout
		screen.add_message("[b]Proctor:[/b] Next question...")
		ask_question()
	else:
		win_game()

func ask_question():
	#Proctor asks question
	if randf() >= mc_to_math_ratio or QuestionData.mc_questions.is_empty():
		curr_question = MathQuestion.new()
		curr_question.difficulty = Question.DIFFICULTY.EASY
		curr_question.generate_question()
		screen.add_message("-----------------------------------------------------------")
		screen.add_message("[b]Proctor:[/b] What is " + curr_question.question_to_string() + "?")
	else:
		curr_question = QuestionData.mc_questions.pop_front()
		screen.add_message("-----------------------------------------------------------")
		screen.add_message("[b]Proctor:[/b] " + curr_question.question + "\nA) " + curr_question.a  + "\nB) " + curr_question.b  + "\nC) " + curr_question.c  + "\nD) " + curr_question.d )
	#15 sec timer to answer or Player shocked
	question_timer.start()

func end_game_player_lost():
	screen.screen_gui.toggle_enter_button()
	# Wait a few seconds until "shock" audio finishes, play bulb burst sfx
	await get_tree().create_timer(8.0).timeout
	transition_screen.transition_to_black()
	await get_tree().create_timer(2.0).timeout
	# Play chat sfx then show lose screen
	ui.show_lose_screen("[center][b]Proctor:[/b] Disappointing, Tester. Very Disappointing.[/center]")
	transition_screen.transition_to_normal()

func end_game_subject_lost():
	screen.screen_gui.toggle_enter_button()
	# Wait a few seconds until "shock" audio finishes, play bulb burst sfx
	await get_tree().create_timer(8.0).timeout
	transition_screen.transition_to_black()
	# Wait for animation to finish
	await get_tree().create_timer(2.0).timeout
	# Play chat sfx then show lose screen
	ui.show_lose_screen("[center][b]Proctor:[/b] Well done, " + player_name + ". You've abandoned your morals...[/center]")
	transition_screen.transition_to_normal()
	

func win_game():
	screen.screen_gui.toggle_enter_button()
	await get_tree().create_timer(5.0).timeout
	screen.add_message("[b]Proctor:[/b] All questions answered. Experiment complete...")
	await get_tree().create_timer(5.0).timeout	
	# Play chat sfx then show lose screen
	ui.show_win_screen("[center][b]Subject:[/b] Thank you, " + player_name + ". Thank you...[/center]")
	await get_tree().create_timer(2.0).timeout
	#play sfx

func strike_subject():
	subjects_strikes += 1
	screen.screen_gui.show_subject_strikes(subjects_strikes)

func strike_player():
	players_strikes += 1
	screen.screen_gui.show_player_strikes(players_strikes)

func _on_screen_gui_pause():
	pass # Replace with function body.

func _on_question_timer_timeout():
	question_timer.stop()
	screen.screen_gui.toggle_enter_button()
	unanswered_questions += 1
	await get_tree().create_timer(2.0).timeout
	screen.add_message("[b]Proctor:[/b] " + player_name + " failed to answer. Administering [i]corrective action[/i].")
	await get_tree().create_timer(2.0).timeout
	strike_player()
	check_ending_or_cont()
	screen.screen_gui.toggle_enter_button()
	


func _on_ui_restart():
	curr_game_state = GAME_STATE.MAIN_MENU
	player_name = ""
	
	players_strikes = 0
	subjects_strikes = 0
	bad_answers = 0
	curr_question = null
	
	total_questions = 0
	unanswered_questions = 0
	wrong_answers = 0
	
	# Clear screen strike markers and timer
	screen.screen_gui.clear_screen()
	# Move Camera to starting position
	camera.global_position = hover_camera_marker.global_position
	camera.global_rotation = hover_camera_marker.global_rotation
