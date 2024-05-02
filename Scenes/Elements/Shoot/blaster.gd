extends Node3D

@onready var raycastShot : RayCast3D = $RayCastShot
@onready var laser : MeshInstance3D = $Laser

func _on_activation(_pickable:XRToolsPickable) -> void:
	$"../BlasterSound".play()
	_pickable.get_picked_up_by_controller().trigger_haptic_pulse("haptic", 300.0, 1.0, 0.05, 0)
	activateLaser()
	get_tree().create_timer(0.05).connect("timeout", deactivateLaser)
	if raycastShot.is_colliding():
		var target = raycastShot.get_collider()
		if target.is_in_group('target') and target.has_method('hit'):
			target.hit()

func activateLaser() -> void:
	laser.visible = true

func deactivateLaser() -> void:
	laser.visible = false

func _on_pickable_object_picked_up(pickable):
	raycastShot.enabled = true


func _on_pickable_object_released(pickable, by):
	raycastShot.enabled = false
