class_name UI extends CanvasLayer

signal restart()

@onready var main_menu = $MainMenu
@onready var option_menu = $OptionMenu
@onready var lose_screen = $LoseScreen
@onready var win_screen = $WinScreen

func show_lose_screen(msg : String):
	#lose_screen.mouse_filter = Control.MOUSE_FILTER_STOP
	lose_screen.message_label.text = msg
	lose_screen.visible = true

func _on_main_menu_start_game():
	main_menu.visible = false
	#main_menu.set_process_input(false)
	#main_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#option_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#lose_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#win_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_main_menu_open_options():
	main_menu.visible = false
	option_menu.visible = true


func _on_option_menu_back():
	option_menu.visible = false
	main_menu.visible = true


func _on_lose_screen_retry():
	lose_screen.visible = false
	main_menu.visible = true
	restart.emit()
