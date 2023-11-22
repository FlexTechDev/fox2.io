extends Node

@export var player_scene: PackedScene;

var had_initial_spawn: bool = false;

func _ready() -> void:
	if multiplayer.is_server() and !had_initial_spawn:
		spawn_initial_players();
		had_initial_spawn = true;
	
	if multiplayer.is_server():
		GlobalNetworkManager.player_joined.connect(_on_player_joined);

func _on_player_joined(id: int) -> void:
	spawn_initial_players.rpc_id(id);
	
	for nid in GlobalNetworkManager.players:
		if nid != id:
			spawn_player.rpc_id(nid, id);
	
	spawn_local_player(id);

func spawn_local_player(id: int) -> void:
	var player_instance: Node3D = player_scene.instantiate();
	
	player_instance.get_child(3).network_id = id;
	
	add_child(player_instance);
	
	player_instance.global_position = Vector3.ZERO;

@rpc("authority", "reliable")
func spawn_initial_players() -> void:
	for id in GlobalNetworkManager.players:
		var player_instance: Node3D = player_scene.instantiate();
		
		player_instance.get_child(3).network_id = id;
		
		add_child(player_instance);
		
		player_instance.global_position = Vector3.ZERO;

@rpc("any_peer", "reliable")
func spawn_player(id: int) -> void:
	var player_instance: Node3D = player_scene.instantiate();
	
	player_instance.get_child(3).network_id = id;
	
	add_child(player_instance);
	
	player_instance.global_position = Vector3.ZERO;
