extends Node3D

func explode() -> void:
	$GPUParticles3D.emitting = true;
	$AnimationPlayer.play("play");
