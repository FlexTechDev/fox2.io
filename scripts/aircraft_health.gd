extends Node3D

@export var health: float = 100;
@export var death_menu_time: float = 5;

func take_local_damage(damage: float) -> void:
	health -= damage;
	
	if health <= 0:
		die();

@rpc("any_peer", "reliable")
func take_damage(damage: float) -> void:
	health -= damage;
	
	if health <= 0:
		die();

func die() -> void:
	$Body.visible = false;
	$Body.velocity = Vector3.ZERO;
	$Body.is_dead = true;
	
	await get_tree().create_timer(death_menu_time).timeout;
	
	$Body.global_position = Vector3.ZERO;
	$Body.visible = true;
	$Body.is_dead = false
