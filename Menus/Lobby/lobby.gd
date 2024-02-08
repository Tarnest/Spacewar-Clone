extends Control

const DEFAULT_PORT = 8910

var peer = null
var address = "127.0.0.1"
@onready var host_button = $Host
@onready var join_button = $Join

func _ready():
	multiplayer.peer_connected.connect(self._player_connected)
	multiplayer.peer_disconnected.connect(self._player_disconnected)
	# multiplayer.connected_to_server.connect(self._connected_ok)
	# multiplayer.connection_failed.connect(self._connected_fail)
	# multiplayer.server_disconnected.connect(self._server_disconnected)
	pass


func _player_connected(_id):
	print("your bluetooth device has connected succesfuullayyy")


func _player_disconnected(_id):
	if multiplayer.is_server():
		print("Client Disconnected")
	else:
		print("Host Disconnected")


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
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, DEFAULT_PORT)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	
	host_button.set_disabled(true)
	join_button.set_disabled(true)
