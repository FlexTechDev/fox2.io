extends Control

@onready var ip: LineEdit = $HBoxContainer/VBoxContainer/Panel2/VBoxContainer/LineEdit;

var connected: bool = false;

func _ready() -> void:
	GlobalNetworkManager.connect_to_network();
	
	GlobalNetworkManager.player_connected.connect(_on_player_connected);

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/testing/island.tscn");

func _on_multiplayer_pressed() -> void:
	var error = GlobalNetworkManager.join_game();
	
	if !connected:
		var error_g = GlobalNetworkManager.create_game();

func _on_player_connected(peer_id, player_info) -> void:
	if peer_id == multiplayer.get_unique_id():
		connected = true;
		GlobalNetworkManager.load_game("res://scenes/testing/multi_island.tscn");
