extends Control

@onready var ip: LineEdit = $HBoxContainer/VBoxContainer/Panel2/VBoxContainer/LineEdit;

var connected: bool = false;

func _ready() -> void:
	GlobalNetworkManager.initialize_multiplayer();
	
	GlobalNetworkManager.server_created.connect(_on_server_created);
	GlobalNetworkManager.server_joined.connect(_on_server_joined);

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/testing/island.tscn");

func _on_host_pressed() -> void:
	GlobalNetworkManager.host_server();

func _on_join_pressed() -> void:
	GlobalNetworkManager.join_server();

func _on_server_created() -> void:
	get_tree().change_scene_to_file("res://scenes/testing/multi_island.tscn");

func _on_server_joined() -> void:
	get_tree().change_scene_to_file("res://scenes/testing/multi_island.tscn");
