class_name GameManager extends Node3D

enum GAME_STATE { MAIN_MENU, PLAYING, PAUSED }

@export var room: TheRoom
@export var room_rot_speed: float = 0.3

var curr_game_state: GAME_STATE = GAME_STATE.MAIN_MENU
var screen: Screen
var seated_camera_marker: Marker3D

# Called when the node enters the scene tree for the first time.
func _ready():
	screen = room.computer_screen
	seated_camera_marker = room.seated_camera_marker

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	room.rotation = lerp(room.rotation, room.rotation + Vector3.UP, delta * room_rot_speed)

func switch_game_state(new_state : GAME_STATE):
	pass
