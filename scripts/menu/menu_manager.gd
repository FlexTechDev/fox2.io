extends Control

@onready var ip: LineEdit = $HBoxContainer/VBoxContainer/Panel2/VBoxContainer/LineEdit;

func _ready() -> void:
	GlobalNetworkManager.connect_to_network();

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/testing/island.tscn");

func _on_multiplayer_pressed() -> void:
	var error = GlobalNetworkManager.join_game();
	
	if error:
		var error_g = GlobalNetworkManager.create_game();
		if !error_g:
			GlobalNetworkManager.load_game.rpc("res://scenes/testing/multi_island.tscn");
	else:
		GlobalNetworkManager.load_game.rpc("res://scenes/testing/multi_island.tscn");
