extends Node3D

func _on_activation(_pickable:XRToolsPickable) -> void:
	$"../BlasterSound".play()
	_pickable.get_picked_up_by_controller().trigger_haptic_pulse("haptic", 300.0, 1.0, 0.05, 0)
	var raycastShot : RayCast3D = $RayCastShot
	raycastShot.force_raycast_update()
	if raycastShot.is_colliding():
		var target = raycastShot.get_collider()
		if target.is_in_group('target') and target.has_method('hit'):
			target.hit()
