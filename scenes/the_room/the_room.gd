class_name TheRoom extends Node3D

enum LIGHT_EFFECT {BLINKING, SURGE}

@onready var computer_screen = $ComputerScreen
@onready var omni_light_3d = $Light/OmniLight3D

@onready var flicker_timer: Timer = $Light/FlickerTimer
@export var flicker_freq: float = 10.0
@export var flicker_dur: float = 0.2
@export var max_flicker_times: int = 3
@export var min_flicker_times: int = 1
@export var dim_mult: float = 0.25

@onready var surge_timer: Timer = $Light/SurgeTimer
@export var surge_freq : float = 0.5
@export var surge_dur : float = 0.3
@export var bright_mult: float = 2.0
@export var brighter_mult: float = 4.0


var curr_light_effect: LIGHT_EFFECT = LIGHT_EFFECT.BLINKING
var original_light_energy: float

# Called when the node enters the scene tree for the first time.
func _ready():
	original_light_energy = omni_light_3d.light_energy
	flicker_timer.start(randf_range(0, flicker_freq))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match curr_light_effect:
		LIGHT_EFFECT.BLINKING:
			pass
		LIGHT_EFFECT.SURGE:
			pass

func _on_flicker_timer_timeout():
	for i in range(randi_range(min_flicker_times, max_flicker_times)):
		omni_light_3d.set_deferred("light_energy", original_light_energy * dim_mult)
		await get_tree().create_timer(flicker_dur).timeout
		omni_light_3d.set_deferred("light_energy", original_light_energy)
		await get_tree().create_timer(flicker_dur).timeout
	flicker_timer.start(randf_range(0, flicker_freq))

func power_surge_on():
	flicker_timer.stop()
	surge_timer.start(surge_freq)

func power_surge_off():
	surge_timer.stop()
	omni_light_3d.set_deferred("light_energy", original_light_energy)
	flicker_timer.start(randf_range(0, flicker_freq))
	


func _on_surge_timer_timeout():
	omni_light_3d.set_deferred("light_energy", original_light_energy * bright_mult)
	await get_tree().create_timer(surge_dur).timeout
	omni_light_3d.set_deferred("light_energy", original_light_energy * brighter_mult)
	await get_tree().create_timer(surge_dur).timeout
	surge_timer.start(surge_freq)
