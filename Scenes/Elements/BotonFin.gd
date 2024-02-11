extends Node3D

signal game_completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interactable_area_button_button_pressed(button: Variant) -> void:
	emit_signal("game_completed")
