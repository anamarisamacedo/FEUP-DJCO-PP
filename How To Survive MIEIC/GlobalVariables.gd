extends Node2D

const pause = preload("res://Scenes/PauseScene.tscn")
const gameOverScreen = preload("res://Scenes/GameOver.tscn")
var current_scene = null
var bookB020Found = false
var bookB031Found = false
var bookLibraryFound = false
var bookLibrary2Found = false
var pause_menu
var game_over

func _input(event):
	if event.is_action_pressed("pause"):
		pause_menu = pause.instance()
		add_child(pause_menu)

func remove_pause():
	remove_child(pause_menu)
	restart_game()

func remove_gameover():
	remove_child(game_over)
	restart_game()
	
func restart_game():
	var timer = get_tree().root.get_node("/root/Global/Timer")
	timer.restart()
	var player = get_tree().root.get_node("/root/Global/Player")
	player.restart()
	goto_scene("res://MainScene.tscn")

func game_win():
	game_over = gameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(true)
	get_tree().paused = true

func game_lost():
	game_over = gameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(false)
	get_tree().paused = true
	

func goto_scene(path):
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count()-1)
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
