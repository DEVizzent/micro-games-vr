extends XRToolsSceneBase

var endGameTimer : SceneTreeTimer

func _ready() -> void:
	if $CommandAudioStream is AudioStreamPlayer:
		$CommandAudioStream.play()
	endGameTimer = get_tree().create_timer(MicroGamesManagerAutoload.getGameTime())
	endGameTimer.timeout.connect(_on_game_finished)

func _on_game_completed() -> void:
	#TODO: Change complete image
	%CompleteMessage.visible = true
	if !$SuccessAudioStream.is_playing() :
		$SuccessAudioStream.play()
	endGameTimer.timeout.disconnect(_on_game_finished)
	get_tree().create_timer(3.0).timeout.connect(_next_minigame)


func _on_game_finished() -> void:
	#TODO: Implement a fail scene to go when fails, also change the user feedback
	%CompleteMessage.visible = true
	if !$FailAudioStream.is_playing() :
		$FailAudioStream.play()
	
	get_tree().create_timer(3.0).timeout.connect(_next_minigame)
	
func _next_minigame() -> void:
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	scene_base.load_scene(MicroGamesManagerAutoload.getNextGame())
