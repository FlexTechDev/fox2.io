extends CharacterBody3D

@export var target_speed: float = 40;
@export var acceleration: float = 4;

var current_speed: float = 0;

func _physics_process(delta: float) -> void:
	current_speed = lerp(current_speed, target_speed, delta * acceleration);
	
	velocity = transform.basis.z * current_speed;
	
	move_and_slide();

func track(target: Node3D) -> void:
	look_at(target.global_position);
