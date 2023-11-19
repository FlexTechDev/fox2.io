extends PanelContainer

@export var radar_node: PackedScene;

var nodes_on_radar: Array[Node3D];
var lock_index: int = 0;
var is_locked: bool = false;

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("toggle_lock"):
			if get_child(lock_index) != null:
				get_child(lock_index).unlock();
				is_locked = false;
				lock_index += 1;
			
			if get_children().size() > lock_index:
				get_child(lock_index).lock();
				is_locked = true;
			else:
				lock_index = 0;
				if get_child(lock_index) != null:
					get_child(lock_index).lock();
					is_locked = true;

func add_node_to_radar(node: Node3D) -> void:
	var radar_instance: Control = radar_node.instantiate();
	
	add_child(radar_instance);
	radar_instance.target = node;
	
	nodes_on_radar.append(node);

func remove_node_from_radar(node: Node3D) -> void:
	
	for child in get_children():
		if child.target == node:
			child.queue_free();
	
	nodes_on_radar.erase(node);
