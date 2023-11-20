extends Control

@onready var ip: LineEdit = $HBoxContainer/VBoxContainer/Panel2/VBoxContainer/LineEdit;

func _ready() -> void:
	GlobalNetworkManager.connect_to_network();

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/testing/island.tscn");

func _on_multiplayer_pressed() -> void:
	GlobalNetworkManager.join_server(ip.text);
	
	if GlobalNetworkManager.connected_to_server:
		get_tree().change_scene_to_file("res://scenes/testing/multi_island.tscn");
	else:
		GlobalNetworkManager.create_server();
		get_tree().change_scene_to_file("res://scenes/testing/multi_island.tscn");
