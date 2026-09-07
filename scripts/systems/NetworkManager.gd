# NetworkManager.gd
# Handles network multiplayer connections (Godot 3.6)

extends Node

var is_network_active = false
var is_host = false
var server_ip = "127.0.0.1"
var server_port = GameConstants.DEFAULT_NETWORK_PORT

signal peer_connected(id)
signal peer_disconnected(id)
signal connection_failed

func _ready():
	set_name("NetworkManager")
	get_tree().connect("connected_ok", self, "_on_connected_ok")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")

func host_game(port: int = GameConstants.DEFAULT_NETWORK_PORT) -> bool:
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(port, 4)
	if err != OK:
		print("Error creating server: ", err)
		return false
	
	get_tree().set_network_peer(peer)
	is_host = true
	is_network_active = true
	print("Server created on port ", port)
	return true

func join_game(ip: String, port: int = GameConstants.DEFAULT_NETWORK_PORT) -> bool:
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_client(ip, port)
	if err != OK:
		print("Error creating client: ", err)
		return false
	
	get_tree().set_network_peer(peer)
	server_ip = ip
	server_port = port
	is_network_active = true
	print("Connecting to ", ip, ":", port)
	return true

func _on_connected_ok() -> void:
	print("Connected to server successfully")
	emit_signal("peer_connected", get_tree().get_network_unique_id())

func _on_connection_failed() -> void:
	print("Connection failed")
	emit_signal("connection_failed")

func _on_server_disconnected() -> void:
	print("Disconnected from server")
	disconnect_from_server()

func disconnect_from_server() -> void:
	if get_tree().network_peer:
		get_tree().network_peer = null
	is_network_active = false
	is_host = false
