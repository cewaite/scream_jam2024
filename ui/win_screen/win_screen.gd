class_name WinScreen extends Control

signal play_again()

@onready var message_label = $MessageLabel
@onready var animation_player = $AnimationPlayer

func play_animation():
	animation_player.play("fade_in")

func reset_win_screen():
	animation_player.play_backwards("fade_in")
	

func _on_play_again_button_pressed():
	play_again.emit()
	reset_win_screen()
