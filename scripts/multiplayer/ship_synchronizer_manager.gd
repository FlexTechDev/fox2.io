extends MultiplayerSynchronizer

var network_id: int = 0;

func _ready() -> void:
	set_multiplayer_authority(network_id);
	
	if is_multiplayer_authority():
		print("in control")
	else:
		get_parent().get_child(0).get_child(3).queue_free();
		get_parent().get_child(0).is_in_control = false;
