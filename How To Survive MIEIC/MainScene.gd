extends Node2D

var timer
const gameOverScreen = preload("res://Scenes/GameOver.tscn")
const player = preload("res://Player.tscn")
const pause = preload("res://Scenes/PauseScene.tscn")
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

func _input(event):
	if event.is_action_pressed("pause"):
		var pause_menu = pause.instance()
		add_child(pause_menu)

func _on_FirstHallway_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/FirstHallway.tscn")

func _on_SecondHallway_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/SecondHallway.tscn")


func _on_ThirdHallway_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/ThirdHallway.tscn")


func _on_OutsideDoor_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Outside.tscn")
