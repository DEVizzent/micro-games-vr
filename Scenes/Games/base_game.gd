extends XRToolsSceneBase

# NEXT: Add other level to the kitchen minigame
# NEXT: Add more levels to the basket minigame

var endGameTimer : SceneTreeTimer

func _ready() -> void:
	_monitoring_game_started()
	if $CommandAudioStream is AudioStreamPlayer:
		$CommandAudioStream.play()
	endGameTimer = get_tree().create_timer(MicroGamesManagerAutoload.getGameTime())
	endGameTimer.timeout.connect(_on_game_finished)

func _on_game_completed() -> void:
	_monitoring_game_ended(true)
	#TODO: Change complete image
	%CompleteMessage.visible = true
	if !$SuccessAudioStream.is_playing() :
		$SuccessAudioStream.play()
	endGameTimer.timeout.disconnect(_on_game_finished)
	get_tree().create_timer(3.0).timeout.connect(_next_minigame)


func _on_game_finished() -> void:
	_monitoring_game_ended(false)
	#TODO: Implement a fail scene to go when fails, also change the user feedback
	%CompleteMessage.visible = true
	if !$FailAudioStream.is_playing() :
		$FailAudioStream.play()
	
	get_tree().create_timer(3.0).timeout.connect(_go_to_menu)
	
func _next_minigame() -> void:
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	scene_base.load_scene(MicroGamesManagerAutoload.getNextGame())

func _go_to_menu() -> void:	
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	scene_base.load_scene("res://Scenes/Menus/start_game.tscn")

func _monitoring_game_started() -> void:
	print('GODOT BEFORE SEND MONITORING')
	FirebaseAnalytics.logEvent(
		FirebaseAnalytics.Event.LEVEL_START,
		{
			FirebaseAnalytics.Param.LEVEL_NAME: str(get_name())
		}
	)
func _monitoring_game_ended(success: bool) -> void:
	print('GODOT BEFORE SEND MONITORING')
	FirebaseAnalytics.logEvent(
		FirebaseAnalytics.Event.LEVEL_END,
		{
			FirebaseAnalytics.Param.LEVEL_NAME: str(get_name()),
			FirebaseAnalytics.Param.SUCCESS: str(success)
		}
	)
