extends Node2D


signal point(to)


var neither_emitted = false


func _on_player_1_hit():
	point.emit("player2")


func _on_player_2_hit():
	point.emit("player1")


func _on_player_hit_player():
	if !neither_emitted:
		neither_emitted = true
		point.emit(null)
