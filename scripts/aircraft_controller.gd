extends CharacterBody3D

@export var settings: AircraftSettings

@onready var water_stream_node: Node3D = get_node("../WaterStreamEffect");
@onready var ship: Node3D = $ship;
@onready var raycast: RayCast3D = $RayCast3D;
@onready var engine_flame: Node3D = $ship/engine_flame;
@onready var sonic_boom_cone: AnimationPlayer = $ship/super_sonic_cone/AnimationPlayer;

var forward_speed: float = 0;
var target_speed: float = 0;

var turn_input: float = 0;
var pitch_input: float = 0;
var smoothed_turn_input: float = 0;
var smoothed_pitch_input: float = 0;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pitch_input = event.relative.y / 25;
		turn_input = -event.relative.x / 25;

func get_input(delta: float) -> void:
	if Input.is_action_pressed("throttle_up"):
		target_speed = min(forward_speed + settings.throttle_delta * delta, settings.max_speed);
	elif Input.is_action_pressed("throttle_down"):
		target_speed = max(forward_speed - settings.throttle_delta * delta, settings.min_speed);
	
	smoothed_turn_input = lerp(smoothed_turn_input, turn_input, settings.lerp_speed * delta);
	smoothed_pitch_input = lerp(smoothed_pitch_input, pitch_input, settings.lerp_speed * delta);
	
func _physics_process(delta: float) -> void:
	get_input(delta);
	
	var up_vector: Vector3 = Vector3.UP;
	up_vector.y *= transform.basis.y.y;
	
	transform.basis = transform.basis.rotated(transform.basis.x, smoothed_pitch_input * settings.pitch_speed * delta);
	transform.basis = transform.basis.rotated(up_vector.normalized(), smoothed_turn_input * settings.turn_speed * delta);
	
	ship.rotation.z = lerp(ship.rotation.z, -turn_input / settings.roll_lean_divisor, settings.level_speed * delta);
	ship.rotation.x = lerp(ship.rotation.x, pitch_input / settings.pitch_lean_divisor, settings.level_speed * delta);
	ship.rotation.y = lerp(ship.rotation.y, turn_input / settings.turn_lean_divisor, settings.level_speed * delta);
	
	forward_speed = lerp(forward_speed, target_speed, settings.acceleration * delta);
	velocity = transform.basis.z * forward_speed;
	
	move_and_slide();
	
	if forward_speed >= AirGlobals.sound_barrier and forward_speed < AirGlobals.sound_barrier + 1:
		sonic_boom_cone.play("boom");
	else:
		sonic_boom_cone.play("idle");
	
	print(forward_speed);
	
	engine_flame.scale.y = target_speed / settings.max_speed;
	
	raycast.global_rotation = Vector3.ZERO;
	
	if raycast.is_colliding():
		var distance: float = 1 - (raycast.get_collision_point().distance_to(raycast.global_position) / abs(raycast.target_position.y));
		water_stream_node.scale.y = distance * distance;
		water_stream_node.global_position = raycast.get_collision_point();
		water_stream_node.rotation.y = ship.global_rotation.y;
	else:
		water_stream_node.scale.y = 0;
