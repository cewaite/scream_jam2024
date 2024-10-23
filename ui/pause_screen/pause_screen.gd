class_name PauseScreen extends Control

func _on_resume_button_pressed():
	hide()
	get_tree().paused = false


func _on_quit_button_pressed():
	get_tree().quit()
