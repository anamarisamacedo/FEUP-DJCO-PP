extends Node2D

const pause = preload("res://Scenes/PauseScene.tscn")
const gameOverScreen = preload("res://Scenes/GameOver.tscn")
var current_scene = null

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
	print(current_scene.name)
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
