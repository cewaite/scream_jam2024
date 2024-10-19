class_name UI extends CanvasLayer

@onready var main_menu = $MainMenu
@onready var option_menu = $OptionMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_menu_start_game():
	self.visible = false
	main_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	option_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_main_menu_open_options():
	main_menu.visible = false
	option_menu.visible = true


func _on_option_menu_back():
	option_menu.visible = false
	main_menu.visible = true
