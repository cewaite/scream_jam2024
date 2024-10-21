class_name LoseScreen extends Control

signal retry()

@onready var message_label = $MessageLabel

func _on_retry_button_pressed():
	retry.emit()
