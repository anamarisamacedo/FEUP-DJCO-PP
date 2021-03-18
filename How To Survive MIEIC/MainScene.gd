extends Node2D

var timer
const gameOverScreen = preload("res://GameOver.tscn")
const player = preload("res://Player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()
	
func start_game():
	pass
	
	
func game_win():
	var game_over = gameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(true)
	get_tree().paused = true

func game_lost():
	var game_over = gameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(false)
	get_tree().paused = true

	
