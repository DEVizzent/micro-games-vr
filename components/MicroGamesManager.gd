class_name MicroGamesManager
extends Node

var easy: Array[String] = [
	"res://Scenes/Games/Kitchen/kitchen1.tscn",
	"res://Scenes/Games/Basket/basket1.tscn",
	"res://Scenes/Games/Button/button1.tscn",
	"res://Scenes/Games/Shoot/shoot1.tscn",
	"res://Scenes/Games/Search/search1.tscn",
]

var medium: Array[String] = [
	"res://Scenes/Games/Kitchen/kitchen2.tscn",
	"res://Scenes/Games/Shoot/shoot2.tscn",
	"res://Scenes/Games/Search/search2.tscn",
]

var hard: Array[String] = [
	"res://Scenes/Games/Shoot/shoot3.tscn",
	"res://Scenes/Games/Search/search3.tscn",
]

var endLessGames: Array[String] = [
	"res://Scenes/Games/Shoot/shoot3.tscn"
]

var counter: int = 0
var game_time: float = 5.0

func getGameTime() -> float:
	return game_time

func getNextGame() -> String:
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
