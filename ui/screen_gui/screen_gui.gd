class_name ScreenGUI extends Control


@onready var scroll_container = %ScrollContainer
@onready var chat_container = %ChatVBoxContainer
@onready var line_edit = %LineEdit
@onready var pause_button = %PauseButton
@onready var enter_button = %EnterButton
@onready var timer_label = %TimerLabel

@export var subject_strike_icons: Array[TextureRect]
@export var player_strike_icons: Array[TextureRect]

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

func _on_enter_button_pressed():
	SignalController.submit_answer.emit(line_edit.text.dedent().capitalize())
	line_edit.clear()

func _on_pause_button_pressed():
	SignalController.pause.emit()
