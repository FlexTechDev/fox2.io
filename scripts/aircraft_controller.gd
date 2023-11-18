extends CharacterBody3D

@export var settings: AircraftSettings

var forward_speed: float = 0;
var target_speed: float = 0;

var turn_input: float = 0;
var pitch_input: float = 0;
var smoothed_turn_input: float = 0;
var smoothed_pitch_input: float = 0;

func get_input(delta: float) -> void:
	if Input.is_action_pressed("throttle_up"):
		target_speed = min(forward_speed + settings.throttle_delta * delta, settings.max_speed);
	elif Input.is_action_pressed("throttle_down"):
		target_speed = max(forward_speed - settings.throttle_delta * delta, settings.min_speed);
	
	turn_input = Input.get_axis("roll_right", "roll_left");
	pitch_input = Input.get_axis("pitch_up", "pitch_down");
	
	smoothed_turn_input = lerp(smoothed_turn_input, turn_input, settings.lerp_speed * delta);
	smoothed_pitch_input = lerp(smoothed_pitch_input, pitch_input, settings.lerp_speed * delta);
	
func _physics_process(delta: float) -> void:
	get_input(delta);
	
	var up_vector: Vector3 = Vector3.UP;
	up_vector.y *= transform.basis.y.y;
	
	transform.basis = transform.basis.rotated(transform.basis.x, smoothed_pitch_input * settings.pitch_speed * delta);
	transform.basis = transform.basis.rotated(up_vector.normalized(), smoothed_turn_input * settings.turn_speed * delta);
	
	$ship.rotation.z = lerp($ship.rotation.z, -turn_input / settings.roll_lean_divisor, settings.level_speed * delta);
	$ship.rotation.x = lerp($ship.rotation.x, pitch_input / settings.pitch_lean_divisor, settings.level_speed * delta);
	$ship.rotation.y = lerp($ship.rotation.y, turn_input / settings.turn_lean_divisor, settings.level_speed * delta);
	
	forward_speed = lerp(forward_speed, target_speed, settings.acceleration * delta);
	velocity = transform.basis.z * forward_speed;
	
	move_and_slide();
	
	$RayCast3D.global_rotation = Vector3.ZERO;
