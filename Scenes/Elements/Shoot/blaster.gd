extends Node3D

func _on_activation(_pickable) -> void:
	$"../BlasterSound".play()
	var raycastShot : RayCast3D = $RayCastShot
	raycastShot.force_raycast_update()
	if raycastShot.is_colliding():
		var target = raycastShot.get_collider()
		if target.is_in_group('target') and target.has_method('hit'):
			target.hit()
