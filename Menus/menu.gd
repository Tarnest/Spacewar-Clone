extends Control

func _on_main_menu_button(type):
	if type == "play":
		$"Main Menu".visible = false
		$"Lobby".visible = true
