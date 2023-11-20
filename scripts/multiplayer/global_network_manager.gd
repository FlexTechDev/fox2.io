extends Node

var server_ip: String;
var port: int = 4400;
var peer: ENetMultiplayerPeer;
var connected_to_server: bool = false;

func connect_to_network() -> void:
	peer = ENetMultiplayerPeer.new();
	
	peer.connected_to_server.connect(_on_connected_to_server);
	peer.connection_failed.connect(_on_connection_failed);
	peer.server_disconnected.connect(_on_server_disconnected);

func _on_connected_to_server() -> void:
	connected_to_server = true;

func _on_connection_failed() -> void:
	connected_to_server = false;

func _on_server_disconnected() -> void:
	connected_to_server = false;

func create_server() -> void:
	peer.create_server(port);

func join_server(ip: String) -> void:
	peer.create_client(ip, port);
	server_ip = ip;
	
