extends Node2D

const pause = preload("res://Scenes/PauseScene.tscn")
const gameOverScreen = preload("res://Scenes/GameOver.tscn")
var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func _input(event):
	if event.is_action_pressed("pause"):
		var pause_menu = pause.instance()
		add_child(pause_menu)

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
	

