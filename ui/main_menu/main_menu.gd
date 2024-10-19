class_name MainMenu extends Control

signal start_game()
signal open_options()

func _on_start_button_pressed():
	start_game.emit()


func _on_options_button_pressed():
	open_options.emit()


func _on_quit_button_pressed():
	get_tree().quit()
