extends CenterContainer

func _ready() -> void:
	_set_panel(1)

func _set_panel(p_no: int)-> void:
	$Main.visible = p_no == 1
	$Volume.visible = p_no == 2
	$Exit.visible = p_no == 3

func _on_cancel_pressed() -> void:
	_set_panel(1)


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_exit_menu_pressed() -> void:
	_set_panel(3)


func _on_options_pressed() -> void:
	_set_panel(2)

func _on_start_pressed() -> void:
	Analytics.round_started()
	MicroGamesManager.init_round()
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	scene_base.load_scene(MicroGamesManager.getNextGame())
