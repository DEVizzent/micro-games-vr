extends Node3D

func _on_activation(_pickable) -> void:
	print("activation")
	var raycastShot : RayCast3D = $RayCastShot
	raycastShot.force_raycast_update()
	if raycastShot.is_colliding():
		print("colliding")
		var target = raycastShot.get_collider()
		if target.is_in_group('target') and target.has_method('hit'):
			print("target hit call")
			target.hit()
