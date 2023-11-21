extends Node

@export var player_scene: PackedScene;

func _ready() -> void:
	GlobalNetworkManager.player_connected.connect(_on_player_connected);
	
	setup_players();

func _on_player_connected(peer_id, player_info) -> void:
	spawn_player.rpc(peer_id);

func setup_players() -> void:
	for id in GlobalNetworkManager.players:
		var player_instance: Node3D = player_scene.instantiate();
		
		player_instance.get_child(0).network_id = GlobalNetworkManager.players[id]["network_id"]
		
		add_child(player_instance);
		
		player_instance.global_position = Vector3.ZERO;

@rpc("any_peer", "reliable")
func spawn_player(network_id) -> void:
	var player_instance: Node3D = player_scene.instantiate();
	
	player_instance.get_child(0).network_id = network_id;
	
	add_child(player_instance);
	
	player_instance.global_position = Vector3.ZERO;
