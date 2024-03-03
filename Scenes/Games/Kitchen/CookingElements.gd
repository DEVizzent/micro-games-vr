extends Node3D

var elements_to_cut : Array[String]
var finished = false

func _ready() -> void:
	EventBus.connect(EventBus.ELEMENT_CUTTED_EVENT, check_completed)
	for node in get_tree().get_nodes_in_group("to_cut"):
		elements_to_cut.append("cutted_" + node.name)

func check_completed()->void:
	if finished:
		return
	var completed = true
	for element in elements_to_cut:
		if get_tree().get_nodes_in_group(element).size() < 3:
			completed = false
	if completed:
		finished = true
		EventBus.emit_signal(EventBus.GAME_COMPLETED_EVENT)

