extends Area3D

signal target_hit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func hit() -> void:
	print("emit signa target hit")
	emit_signal("target_hit")
