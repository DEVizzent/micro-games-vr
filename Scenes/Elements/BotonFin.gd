extends Node3D

func _on_interactable_area_button_button_pressed(_button: Variant) -> void:
	EventBus.emit_signal(EventBus.GAME_COMPLETED_EVENT)
