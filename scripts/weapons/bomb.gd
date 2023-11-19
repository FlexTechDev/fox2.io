extends CharacterBody3D

@export var target_speed: float = 40;
@export var acceleration: float = 4;
@export var explosion_scene: PackedScene;
@export var gravity_constant: float = -0.1;
@export var terminal_velocity: float = -10;

var current_speed: float = 0;
var last_fall_velocity: float = 0;

func _physics_process(delta: float) -> void:
	
	if target_speed < current_speed:
		current_speed = lerp(current_speed, target_speed, delta * acceleration);
	
	velocity = (transform.basis.z * current_speed);
	
	velocity.y = last_fall_velocity + gravity_constant;
	velocity.y = clamp(velocity.y, terminal_velocity, INF);
	
	last_fall_velocity = velocity.y;
	
	move_and_slide();
	
	for i in get_slide_collision_count():
		var collision: KinematicCollision3D = get_slide_collision(i);
		
		explode();

func explode() -> void:
	var explosion_instance: Node3D = explosion_scene.instantiate();
	
	get_tree().current_scene.add_child(explosion_instance);
	
	explosion_instance.global_position = global_position;
	explosion_instance.global_rotation = global_rotation;
	explosion_instance.explode();
	
	queue_free();

func track(target: Node3D) -> void:
	look_at(target.global_position);
