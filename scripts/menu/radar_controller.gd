extends Camera3D

@onready var hud: Control = get_node("../../Control/HUD");

func _on_body_enter_radar(body: Node3D) -> void:
	if body.has_meta("target") and body.get_meta("target"):
		hud.add_node_to_radar(body);

func _on_body_exit_radar(body: Node3D) -> void:
	if body.has_meta("target") and body.get_meta("target"):
		hud.remove_node_from_radar(body);
