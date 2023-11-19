extends Control

@export var lock_color: Color = Color.INDIAN_RED;
@export var non_lock_color: Color = Color.WHITE;

var target: Node3D;
var is_locked: bool;

func lock() -> void:
	is_locked = true;
	$TextureRect.modulate = lock_color;

func unlock() -> void:
	is_locked = false;
	$TextureRect.modulate = non_lock_color;

func _process(delta: float) -> void:
	
	if target == null:
		queue_free();
	
	position = get_viewport().get_camera_3d().unproject_position(target.global_position);
