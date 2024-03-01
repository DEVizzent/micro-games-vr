extends Node3D

signal game_completed

func _on_area_3d_body_entered(body: Node3D) -> void:
	emit_signal("game_completed")
