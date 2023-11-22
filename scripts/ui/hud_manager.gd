extends PanelContainer

@export var radar_node: PackedScene;

var nodes_on_radar: Array[Node3D];
var lock_index: int = 0;
var is_locked: bool = false;
var last_locked: Control;

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed("toggle_lock"):
			lock_index += 1;
			
			if nodes_on_radar.size() < lock_index:
				lock_index = 0;
			
			if nodes_on_radar.size() > 0 and nodes_on_radar.size() >= lock_index:
				if last_locked != null:
					last_locked.unlock();
					last_locked = null;
					is_locked = false;
				
				last_locked = get_child(lock_index);
				
				if last_locked != null:
					last_locked.lock();
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
