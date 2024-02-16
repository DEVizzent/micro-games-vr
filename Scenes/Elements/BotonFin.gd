extends Node3D

signal game_completed

func _on_interactable_area_button_button_pressed(button: Variant) -> void:
	print('game completed emitted')
	emit_signal("game_completed")
