extends Node

@export var networked_ship_scene: PackedScene;

func _ready() -> void:
	GlobalNetworkManager.peer.peer_connected.connect(_on_peer_connected);
	GlobalNetworkManager.peer.peer_disconnected.connect(_on_peer_disconnected);

func _on_peer_connected(id: int) -> void:
	var ship_instance = networked_ship_scene.instantiate();
	
	ship_instance.position = Vector3.ZERO;

func _on_peer_disconnected(id: int) -> void:
	pass
