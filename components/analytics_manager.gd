extends Node
class_name AnalyticsManager

const UUID = preload('res://addons/godot-uuid/uuid.gd')

const CUSTOM_EVENT_ROUND_STARTED = "round_started"
const CUSTOM_EVENT_ROUND_ENDED = "round_ended"

const CUSTOM_PARAMETER_ROUND_UUID = "round_uuid"
const CUSTOM_PARAMETER_COMPLETED_GAMES = "completed_games"

var roundOfGamesUUID: String

func round_started() -> void:
	roundOfGamesUUID = UUID.v4()
	FirebaseAnalytics.logEvent(
		CUSTOM_EVENT_ROUND_STARTED,
		{
			CUSTOM_PARAMETER_ROUND_UUID: roundOfGamesUUID
		}
	)

func round_ended(completed_games: int) -> void:
	FirebaseAnalytics.logEvent(
		CUSTOM_EVENT_ROUND_ENDED,
		{
			CUSTOM_PARAMETER_ROUND_UUID: roundOfGamesUUID,
			CUSTOM_PARAMETER_COMPLETED_GAMES: completed_games
		}
	)

func game_started(game_name: String) -> void:
	FirebaseAnalytics.logEvent(
		FirebaseAnalytics.Event.LEVEL_START,
		{
			FirebaseAnalytics.Param.LEVEL_NAME: game_name,
			CUSTOM_PARAMETER_ROUND_UUID: roundOfGamesUUID
		}
	)

func game_ended(game_name: String, success: int) -> void:
	FirebaseAnalytics.logEvent(
		FirebaseAnalytics.Event.LEVEL_END,
		{
			FirebaseAnalytics.Param.LEVEL_NAME: game_name,
			FirebaseAnalytics.Param.SUCCESS: success,
			CUSTOM_PARAMETER_ROUND_UUID: roundOfGamesUUID
		}
	)
