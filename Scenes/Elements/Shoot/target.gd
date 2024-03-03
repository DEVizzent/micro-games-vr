extends Area3D

var isHit:bool

func _ready() -> void:
	isHit = false

func hit() -> void:
	if isHit:
		return
	isHit = true
	remove_from_group("target")
	check_completed()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", Vector3(0, 15.7, 0), 1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", Vector3(0, 0, 0), .5).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(queue_free)

func check_completed() -> void:
	if get_tree().get_nodes_in_group("target").size() < 1 :
		EventBus.emit_signal(EventBus.GAME_COMPLETED_EVENT)
