extends Control


signal play


func _on_main_menu_button(type):
	if type == "play":
		$"Main Menu".visible = false
		play.emit()
