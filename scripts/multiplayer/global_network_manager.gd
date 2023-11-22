extends Node

signal server_created;
signal server_joined;
signal player_joined(id: int);
signal player_left(id: int);
signal player_list_updated;

const default_address: String = "127.0.0.1";
const default_port: int = 4343;
const max_clients: int = 10;

var peer: ENetMultiplayerPeer;

var players = {};
var player_data = {
	"network_id": 0,
};

func initialize_multiplayer() -> void:
	multiplayer.peer_connected.connect(_on_player_connected);
	multiplayer.peer_disconnected.connect(_on_player_disconnected);
	multiplayer.connected_to_server.connect(_on_connected_to_server);
	multiplayer.server_disconnected.connect(_on_server_disconnect);

func _on_player_connected(id: int) -> void:
	if !players.has(id):
		players[id] = {
			"network_id": id,
		};
		
		sync_player_list();
	
	player_joined.emit(id);

func _on_player_disconnected(id: int) -> void:
	if players.has(id):
		players.erase(id);
		
		sync_player_list();
	
	player_left.emit(id);

func _on_connected_to_server() -> void:
	server_joined.emit();

func _on_server_disconnect() -> void:
	pass

func host_server(port: int = default_port) -> void:
	peer = ENetMultiplayerPeer.new();
	var error = peer.create_server(port, max_clients);
	
	if error != OK:
		print("cannot host server on " + default_address + ":" + str(port));
		return;
	
	peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER);
	
	multiplayer.multiplayer_peer = peer;
	print("server made on " + default_address + ":" + str(port));
	
	players[multiplayer.get_unique_id()] = {
		"network_id": multiplayer.get_unique_id(),
	};
	
	sync_player_list();
	
	server_created.emit();

func join_server(ip: String = default_address, port: int = default_port) -> void:
	peer = ENetMultiplayerPeer.new();
	peer.create_client(ip, port);
	peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER);
	multiplayer.multiplayer_peer = peer;
	
	print("connected to server at " + default_address + ":" + str(port))

@rpc("any_peer", "call_local")
func send_player_list(id: int, list) -> void:
	if !players.has(id):
		players[id] = {
			"network_id":id,
		}
		
		players = list;
	
	player_list_updated.emit();

func sync_player_list() -> void:
	if multiplayer.is_server():
		for id in players:
			send_player_list.rpc(id, players);
