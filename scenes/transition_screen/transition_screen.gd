class_name TransitionScreen extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func transition_to_black():
	color_rect.visible = true
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("fade_to_black")

func transition_to_normal():
	color_rect.visible = true
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	animation_player.play("fade_to_normal")
