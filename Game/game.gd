extends Node2D

signal point(to)
@onready var player1 = $Player1
@onready var player2 = $Player2
var hit_emitted = false

func _ready():
	if multiplayer.is_server():
		player2.set_multiplayer_authority(multiplayer.get_peers()[0])
	else:
		player2.set_multiplayer_authority(multiplayer.get_unique_id())
	
	var screen_size = get_viewport().size
	player1.position = Vector2(player1.scale.x * 32, screen_size.y / 2)
	player2.position = Vector2(screen_size.x - player1.scale.x * 32, screen_size.y / 2)


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


