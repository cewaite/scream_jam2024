class_name CreditsPage
extends Control

signal back()

func _on_back_button_pressed():
	back.emit()
