extends XRToolsSceneBase

func _ready() -> void:
	if $CommandAudioStream is AudioStreamPlayer:
		$CommandAudioStream.play()

func _on_game_completed() -> void:
	$CompleteMessage.visible = true
	if !$SuccessAudioStream.is_playing() :
		$SuccessAudioStream.play()
	
	get_tree().create_timer(3.0).timeout.connect(_next_minigame)
	
func _next_minigame() -> void:
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	scene_base.load_scene(MicroGamesManagerAutoload.getNextGame())
