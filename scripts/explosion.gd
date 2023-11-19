extends Node3D

func explode() -> void:
	$GPUParticles3D.emitting = true;
	$AnimationPlayer.play("play");
	
	await get_tree().create_timer(1.5).timeout;
	
	queue_free();

