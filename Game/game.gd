extends Node2D


signal point(to)


var hit_emitted = false


func _on_player_1_hit():
	hit("player2")


func _on_player_2_hit():
	hit("player1")


func _on_player_hit_player():
	hit(null)


func hit(point_to):
	if !hit_emitted:
		hit_emitted = true
		point.emit(point_to)
