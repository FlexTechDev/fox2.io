extends CharacterBody3D

@export var target_speed: float = 40;
@export var acceleration: float = 4;
@export var explosion_scene: PackedScene;

var current_speed: float = 0;
var target: Node3D;

func _physics_process(delta: float) -> void:
	current_speed = lerp(current_speed, target_speed, delta * acceleration);
	
	if(target != null):
		velocity = -transform.basis.z * current_speed
		look_at(target.global_position);
	else:
		velocity = transform.basis.z * current_speed
	
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
	
	for body in $DamageRadius.get_overlapping_bodies():
		if body.get_parent().has_method("take_damage"):
			body.get_parent().take_damage.rpc(100-global_position.distance_to(body.global_position));
	
	queue_free();

func track(target: Node3D) -> void:
	look_at(target.global_position);
