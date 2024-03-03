extends XRToolsSceneBase

# NEXT: Add other level to the kitchen minigame

@export_range(-5,5,0.1) var game_time_modifier : float = 0.0
var endGameTimer : SceneTreeTimer

func _ready() -> void:
	EventBus.connect(EventBus.GAME_COMPLETED_EVENT, _on_game_completed)
	_monitoring_game_started()
	if $CommandAudioStream is AudioStreamPlayer:
		$CommandAudioStream.play()
	endGameTimer = get_tree().create_timer(MicroGamesManager.getGameTime() + game_time_modifier)
	endGameTimer.timeout.connect(_on_game_finished)

func _on_game_completed() -> void:
	_monitoring_game_ended(1)
	if !$SuccessAudioStream.is_playing() :
		$SuccessAudioStream.play()
	endGameTimer.timeout.disconnect(_on_game_finished)
	get_tree().create_timer(3.0).timeout.connect(_next_minigame)


func _on_game_finished() -> void:
	_monitoring_game_ended(0)
	if !$FailAudioStream.is_playing() :
		$FailAudioStream.play()
	
	get_tree().create_timer(3.0).timeout.connect(_go_to_menu)
	
func _next_minigame() -> void:
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	scene_base.load_scene(MicroGamesManager.getNextGame())

func _go_to_menu() -> void:	
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	scene_base.load_scene("res://Scenes/Menus/start_game.tscn")

func _monitoring_game_started() -> void:
	FirebaseAnalytics.logEvent(
		FirebaseAnalytics.Event.LEVEL_START,
		{
			FirebaseAnalytics.Param.LEVEL_NAME: str(get_name())
		}
	)
func _monitoring_game_ended(success: int) -> void:
	FirebaseAnalytics.logEvent(
		FirebaseAnalytics.Event.LEVEL_END,
		{
			FirebaseAnalytics.Param.LEVEL_NAME: str(get_name()),
			FirebaseAnalytics.Param.SUCCESS: success
		}
	)
