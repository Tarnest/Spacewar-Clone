extends Control

signal button(type)


func _ready():
	var screen_size = get_viewport().size
	position = screen_size * 0.5 - size / 2


func _on_play_pressed():
	button.emit("play")


func _on_options_pressed():
	button.emit("options")


func _on_quit_pressed():
	get_tree().quit()
