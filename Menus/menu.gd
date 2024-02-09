extends Control

var game_start

func _process(_delta):
	if Input.is_action_just_pressed("pause") && (game_start || !multiplayer.is_server()):
		$"Pause Menu".visible = !$"Pause Menu".visible


func _on_main_menu_button(type):
	if type == "play":
		$"Main Menu".visible = false
		$"Lobby".visible = true


func _on_start_pressed():
	game_start = true
