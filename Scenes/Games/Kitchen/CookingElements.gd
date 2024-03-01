extends Node3D

var elements_to_cut : Array[String]
signal game_completed

func _ready() -> void:
	$"../Knife/SlicerArea".connect("element_cutted", check_completed)	
	for node in get_tree().get_nodes_in_group("to_cut"):
		elements_to_cut.append("cutted_" + node.name)

func check_completed() -> void:
	var completed = true
	for element in elements_to_cut:
		if get_tree().get_nodes_in_group(element).size() < 3:
			completed = false
	if completed:
		emit_signal("game_completed")

