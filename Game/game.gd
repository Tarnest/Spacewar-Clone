extends Node2D

signal point(to)

@onready var player2 = $Player2
var hit_emitted = false

func _ready():
	if multiplayer.is_server():
		player2.set_multiplayer_authority(multiplayer.get_peers()[0])
	else:
		player2.set_multiplayer_authority(multiplayer.get_unique_id())


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


