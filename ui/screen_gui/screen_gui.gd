class_name ScreenGUI extends Control


@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var chat_container = %ChatVBoxContainer
@onready var line_edit = %LineEdit
@onready var pause_button = %PauseButton
@onready var enter_button = %EnterButton
@onready var timer_label = %TimerLabel

@export var subject_strike_icons: Array[TextureRect]
@export var player_strike_icons: Array[TextureRect]

@export var key_click_audio: AudioStreamPlayer3D
@export var key_sfx: Array[AudioStream]

# Called when the node enters the scene tree for the first time.
func _ready():
	enter_button.disabled = true

func toggle_enter_button():
	enter_button.disabled = !enter_button.disabled

func show_subject_strikes(num_strikes: int):
	if num_strikes <= subject_strike_icons.size():
		subject_strike_icons[num_strikes - 1].visible = true

func show_player_strikes(num_strikes: int):
	if num_strikes <= player_strike_icons.size():
		player_strike_icons[num_strikes - 1].visible = true

func clear_screen():
	timer_label.text = "0.00"
	line_edit.clear()
	for icon in subject_strike_icons:
		icon.visible = false
	for icon in player_strike_icons:
		icon.visible = false
	for msg in chat_container.get_children():
		msg.queue_free()

func _on_enter_button_pressed():
	SignalController.submit_answer.emit(line_edit.text.dedent().capitalize())
	line_edit.clear()

func _on_pause_button_pressed():
	SignalController.pause.emit()


func _on_line_edit_text_submitted(new_text):
	if not enter_button.disabled:
		SignalController.submit_answer.emit(line_edit.text.dedent().capitalize())
		line_edit.clear()


func _on_line_edit_text_changed(new_text):
	key_click_audio.stream = key_sfx.pick_random()
	key_click_audio.play()
