extends CharacterBody3D

@export var settings: AircraftSettings
@export var missile_scene: PackedScene;
@export var bomb_scene: PackedScene;

@onready var launch_point: Node3D = $ship/LaunchPoint;
@onready var water_stream_node: Node3D = get_node("../WaterStreamEffect");
@onready var ship: Node3D = $ship;
@onready var raycast: RayCast3D = $RayCast3D;
@onready var engine_flame: Node3D = $ship/engine_flame;
@onready var sonic_boom_cone: AnimationPlayer = $ship/super_sonic_cone/AnimationPlayer;
@onready var hud: Control = get_node("../Control/HUD");


var is_in_control: bool = true;
var forward_speed: float = 0;
var target_speed: float = 0;

var turn_input: float = 0;
var pitch_input: float = 0;
var smoothed_turn_input: float = 0;
var smoothed_pitch_input: float = 0;

var mouse_captured: bool = true;

func _ready() -> void:
	if !is_in_control:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _input(event: InputEvent) -> void:
	if !is_in_control:
		return;
	
	if event is InputEventMouseMotion and mouse_captured:
		pitch_input = event.relative.y / 25;
		turn_input = -event.relative.x / 25;
	if event is InputEventJoypadMotion:
		pitch_input = Input.get_axis("pitch_up", "pitch_down") * 2;
		turn_input = Input.get_axis("turn_right", "turn_left") * 2;
		
func get_input(delta: float) -> void:
	if Input.is_action_pressed("throttle_up"):
		target_speed = min(forward_speed + settings.throttle_delta * delta, settings.max_speed);
	elif Input.is_action_pressed("throttle_down"):
		target_speed = max(forward_speed - settings.throttle_delta * delta, settings.min_speed);
	
	smoothed_turn_input = lerp(smoothed_turn_input, turn_input, settings.lerp_speed * delta);
	smoothed_pitch_input = lerp(smoothed_pitch_input, pitch_input, settings.lerp_speed * delta);
	
func _physics_process(delta: float) -> void:
	sonic_boom_cone.play("idle");
	
	if !is_in_control:
		return;
	
	get_input(delta);
	
	if Input.is_action_just_pressed("escape"):
		mouse_captured = !mouse_captured;
		if mouse_captured:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	
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
	
	if Input.is_action_just_pressed("fire_missile"):
		fire_missile();
	if Input.is_action_just_pressed("drop_bomb"):
		drop_bomb();
	
	engine_flame.scale.y = target_speed / settings.max_speed;
	
	raycast.global_rotation = Vector3.ZERO;
	
	if raycast.is_colliding():
		var distance: float = 1 - (raycast.get_collision_point().distance_to(raycast.global_position) / abs(raycast.target_position.y));
		water_stream_node.scale.y = distance * distance;
		water_stream_node.global_position = raycast.get_collision_point();
		water_stream_node.rotation.y = ship.global_rotation.y;
	else:
		water_stream_node.scale.y = 0;

func drop_bomb(target: Node3D = null) -> CharacterBody3D:
	var bomb_instance = bomb_scene.instantiate();
	
	get_tree().current_scene.add_child(bomb_instance);
	bomb_instance.global_position = launch_point.global_position;
	bomb_instance.global_rotation = launch_point.global_rotation;
	
	bomb_instance.current_speed = forward_speed;
	bomb_instance.last_fall_velocity = velocity.y;
	
	return bomb_instance;

func fire_missile(target: Node3D = null) -> CharacterBody3D:
	var missile_instance = missile_scene.instantiate();
	
	get_tree().current_scene.add_child(missile_instance);
	missile_instance.global_position = launch_point.global_position;
	missile_instance.global_rotation = launch_point.global_rotation;
	
	if hud.nodes_on_radar.size() > hud.lock_index and hud.is_locked:
		missile_instance.target = hud.nodes_on_radar[hud.lock_index];
	
	missile_instance.current_speed = forward_speed;
	
	return missile_instance;
