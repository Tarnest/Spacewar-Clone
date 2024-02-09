extends CanvasLayer


const WINNING_SCORE = 5

@onready var left_score = $ScoreLeft
@onready var right_score = $ScoreRight

var player1_score = 0
var player2_score = 0
var scene = preload("res://Game/game.tscn")


func _ready():
	var screen_size = get_viewport().size
	left_score.position = screen_size * 0.1 - left_score.size / 2
	right_score.position.x = screen_size.x * 0.9 - right_score.size.x / 2
	right_score.position.y = screen_size.y * 0.1 - right_score.size.y / 2

@rpc("any_peer", "call_local")
func _on_game_point(to):
	rpc("add_point", to)
	
	if player1_score >= WINNING_SCORE:
		print("player1 wins")
	if player2_score >= WINNING_SCORE:
		print("player2 wins")
	
	for child in get_children():
		if child.is_in_group("Game"):
			child.queue_free()
			print("queued free")
			break
	
	spawn_game()


func spawn_game():
	var game = scene.instantiate()
	game.connect("point", Callable(self, "_on_game_point"))
	call_deferred("add_child", game, true)
	
	rpc("show_score")



func _on_lobby_start_game():
	spawn_game()


func _on_lobby_end_game():
	print(get_tree())


@rpc("any_peer", "call_local")
func show_score():
	left_score.visible = true
	right_score.visible = true


@rpc("any_peer", "call_local")
func add_point(to):
	match to:
		"player1": player1_score += 1
		"player2": player2_score += 1
		_: pass
	
	left_score.text = str(player1_score)
	right_score.text = str(player2_score)
