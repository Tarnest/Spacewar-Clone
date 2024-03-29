extends CanvasLayer


var player1_score = 0
var player2_score = 0
var scene = preload("res://Game/game.tscn")


func _on_game_point(to):
	match to:
		"player1": player1_score += 1
		"player2": player2_score += 1
		_: pass
	
	print(player1_score)
	print(player2_score)
	
	
	for child in get_children():
		if child.is_in_group("Game"):
			child.queue_free()
			break
	
	spawn_game()


func _on_menu_play():
	spawn_game()


func spawn_game():
	var game = scene.instantiate()
	game.connect("point", Callable(self, "_on_game_point"))
	call_deferred("add_child", game)

