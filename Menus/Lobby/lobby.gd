extends Control

signal start_game
signal end_game

const DEFAULT_PORT = 3478

@export var main: CanvasLayer

var peer = null
@onready var address = $Address
@onready var host_button = $Host
@onready var join_button = $Join
@onready var start_button = $Start

func _ready():
	multiplayer.peer_connected.connect(self._player_connected)
	multiplayer.peer_disconnected.connect(self._player_disconnected)
	multiplayer.server_disconnected.connect(self._server_disconnected)
	# multiplayer.connected_to_server.connect(self._connected_ok)
	# multiplayer.connection_failed.connect(self._connected_fail)


func _player_connected(_id):
	print("your bluetooth device has connected succesfuullayyy")
	if multiplayer.is_server():
		start_button.visible = true


func _player_disconnected(_id):
	if multiplayer.is_server():
		print("Client Disconnected")
	else:
		print("Host Disconnected")
	disconnected()


func _server_disconnected():
	disconnected()
	print("Server Disconnected")


func _on_host_pressed():
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(DEFAULT_PORT, 1)
	
	if err != OK:
		print("Something went wrong")
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	host_button.set_disabled(true)
	join_button.set_disabled(true)


func _on_join_pressed():
	var ip = address.text
	if not ip.is_valid_ip_address():
		return
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, DEFAULT_PORT)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	
	host_button.set_disabled(true)
	join_button.set_disabled(true)


func _on_start_pressed():
	start_game.emit()
	rpc("_hide")


@rpc("any_peer", "call_local")
func _hide():
	start_button.visible = false
	host_button.visible = false
	join_button.visible = false
	address.visible = false


func _show():
	host_button.visible = true
	join_button.visible = true
	address.visible = true

func disconnected():
	for child in main.get_children():
		if child.is_in_group("Game"):
			queue_free()
			break
	
	
	if multiplayer != null:
		print("ello")
		multiplayer.set_multiplayer_peer(null)
		_show()
		host_button.set_disabled(false)
		join_button.set_disabled(false)
	end_game.emit()


func _on_leave_pressed():
	if multiplayer != null:
		multiplayer.player_disconnected.emit()
