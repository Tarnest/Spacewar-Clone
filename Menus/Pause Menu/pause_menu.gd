extends Control

signal pause_button_pressed(button_type)


func _ready():
	var screen_size = get_viewport().size
	position = screen_size * 0.5 - size / 2


func _on_resume_pressed():
	pause_button_pressed.emit("resume")


func _on_options_pressed():
	pause_button_pressed.emit("options")


func _on_leave_pressed():
	get_tree().change_scene_to_file("res://Main/main.tscn")
