extends Node
@onready var ui = $GameManager/UI
@onready var game_manager: GameManager = $GameManager

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape") and game_manager.curr_game_state == game_manager.GAME_STATE.PLAYING:
		get_tree().paused = true
		ui.show_pause_screen()
