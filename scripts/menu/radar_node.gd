extends Control

var target: Node3D;
var is_locked: bool;

func lock() -> void:
	is_locked = true;
	$AnimationPlayer.play("lock");

func unlock() -> void:
	is_locked = false;
	$AnimationPlayer.play("unlock");

func _process(delta: float) -> void:
	
	if target == null:
		queue_free();
	
	position = get_viewport().get_camera_3d().unproject_position(target.global_position);
