class_name MicroGamesManagerScript
extends Node
const EASY_GAMES: Array[String] = [
	"res://Scenes/Games/Birthday/birthday1.tscn",
	"res://Scenes/Games/Kitchen/kitchen1.tscn",
	"res://Scenes/Games/Basket/basket1.tscn",
	"res://Scenes/Games/Button/button1.tscn",
	"res://Scenes/Games/Shoot/shoot1.tscn",
	"res://Scenes/Games/Search/search1.tscn",
	"res://Scenes/Games/Spiderman/spiderman1.tscn",
]
const MEDIUM_GAMES: Array[String] = [
	"res://Scenes/Games/Kitchen/kitchen2.tscn",
	"res://Scenes/Games/Basket/basket2.tscn",
	"res://Scenes/Games/Shoot/shoot2.tscn",
	"res://Scenes/Games/Search/search2.tscn",
	"res://Scenes/Games/Spiderman/spiderman2.tscn",
]
const HARD_GAMES: Array[String] = [
	"res://Scenes/Games/Kitchen/kitchen2.tscn",
	"res://Scenes/Games/Basket/basket3.tscn",
	"res://Scenes/Games/Shoot/shoot3.tscn",
	"res://Scenes/Games/Search/search3.tscn",
	"res://Scenes/Games/Spiderman/spiderman3.tscn",
]
const ENDLESS_GAMES: Array[String]  = [
	"res://Scenes/Games/Shoot/shoot3.tscn",
	"res://Scenes/Games/Basket/basket3.tscn",
	"res://Scenes/Games/Kitchen/kitchen2.tscn",
	"res://Scenes/Games/Spiderman/spiderman3.tscn",
]

var test: Array[String] = [
	# "res://Scenes/Games/Spiderman/spiderman1.tscn",
	# "res://Scenes/Games/Spiderman/spiderman2.tscn",
	# "res://Scenes/Games/Spiderman/spiderman3.tscn",
]
var easy: Array[String]
var medium: Array[String]
var hard: Array[String]
var endLessGames: Array[String]

var counter: int = 0
var game_time: float = 5.0

func _ready()-> void:
	endLessGames = ENDLESS_GAMES.duplicate()
	init_round()

func init_round() -> void:
	easy = EASY_GAMES.duplicate()
	medium = MEDIUM_GAMES.duplicate()
	hard = HARD_GAMES.duplicate()
	game_time = 5.0
	counter = 0

func getGameTime() -> float:
	return game_time

func getNextGame() -> String:
	if !test.is_empty():
		return test.pop_front()
	counter += 1
	if easy.size() > 0:
		var game = easy.pick_random()
		easy.erase(game)
		return game
	if medium.size() > 0:
		var game = medium.pick_random()
		medium.erase(game)
		return game
	if hard.size() > 0:
		var game = hard.pick_random()
		hard.erase(game)
		return game
	game_time -= 0.1
	return endLessGames.pick_random()

func getGameCount() -> int:
	return counter
