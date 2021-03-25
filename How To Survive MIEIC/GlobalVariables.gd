extends Node2D

const pause = preload("res://Scenes/PauseScene.tscn")
const gameOverScreen = preload("res://Scenes/GameOver.tscn")
var current_scene = null
var bookB020Found = false
var bookB031Found = false
var bookLibraryFound = false
var bookLibrary2Found = false
var beerFirstHallwayPicked = false
var beerSecondHallwayPicked = false
var beerThirdHallwayPicked = false
var beerMainScenePicked = false
var beer2MainScenePicked = false
var beer3MainScenePicked = false
var beer4MainScenePicked = false
var beer5MainScenePicked = false
var beerOutsidePicked = false
var beerOutside2Picked = false
var beerB130ScenePicked = false
var beerLibraryPicked = false
var beerLibrary2Picked = false
var beerThirdHallway2Picked = false
var bookMainScenePicked = false
var pause_menu
var game_over
enum QuestStatus { NOT_STARTED, STARTED, PROJECT, COMPLETED }
var quest_status_professor1 = QuestStatus.NOT_STARTED
var quest_status_professor2 = QuestStatus.NOT_STARTED
var quest_status_professor3 = QuestStatus.NOT_STARTED
var quest_status_professor4 = QuestStatus.NOT_STARTED
var quest_status_praxis_project = QuestStatus.NOT_STARTED
var quest_status_praxis_cheater = QuestStatus.NOT_STARTED
enum Player_positions { INITIAL_POSITION, FIRST_BACK_POSITION, SECOND_BACK_POSITION, THIRD_BACK_POSITION, OUTSIDE_BACK_POSITION, LIBRARY_BACK_POSITION, OUTSIDE_POSITION, LIBRARY2_BACK_POSITION, THIRDHALLWAY2_BACK_POSITION }
var player_position = Player_positions.INITIAL_POSITION
var player

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	
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
	player.restart()
	quest_status_professor1 = QuestStatus.NOT_STARTED
	quest_status_professor2 = QuestStatus.NOT_STARTED
	quest_status_professor3 = QuestStatus.NOT_STARTED
	quest_status_professor4 = QuestStatus.NOT_STARTED
	quest_status_praxis_project = QuestStatus.NOT_STARTED
	quest_status_praxis_cheater = QuestStatus.NOT_STARTED
	bookB020Found = false
	bookB031Found = false
	bookLibraryFound = false
	bookLibrary2Found = false
	beerFirstHallwayPicked = false
	beerSecondHallwayPicked = false
	beerThirdHallwayPicked = false
	beerMainScenePicked = false
	beer2MainScenePicked = false
	beer3MainScenePicked = false
	beer4MainScenePicked = false
	beer5MainScenePicked = false
	beerOutsidePicked = false
	beerOutside2Picked = false
	beerB130ScenePicked = false
	beerLibraryPicked = false
	beerLibrary2Picked = false
	beerThirdHallway2Picked = false
	bookMainScenePicked = false
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
	
	if current_scene.name == "MainScene": 
		if player_position == Player_positions.FIRST_BACK_POSITION:
			player.position = get_tree().root.get_node("/root/"+ current_scene.name + "/FirstBackPosition").position
		if player_position == Player_positions.SECOND_BACK_POSITION:
			player.position = get_tree().root.get_node("/root/"+ current_scene.name + "/SecondBackPosition").position
		if player_position == Player_positions.THIRD_BACK_POSITION:
			player.position = get_tree().root.get_node("/root/"+ current_scene.name + "/ThirdBackPosition").position	
		if player_position == Player_positions.OUTSIDE_BACK_POSITION:
			player.position = get_tree().root.get_node("/root/"+ current_scene.name + "/OutsideBackPosition").position	
	if current_scene.name == "Outside":
		if player_position == Player_positions.OUTSIDE_POSITION:
			player.position = get_tree().root.get_node("/root/"+ current_scene.name + "/OutsidePosition").position	
		if player_position == Player_positions.LIBRARY_BACK_POSITION:
			player.position = get_tree().root.get_node("/root/"+ current_scene.name + "/LibraryBackPosition").position	
	if current_scene.name == "Library":
		if player_position == Player_positions.LIBRARY2_BACK_POSITION:
			player.position = get_tree().root.get_node("/root/"+ current_scene.name + "/Library2BackPosition").position	
	if current_scene.name == "ThirdHallway":
		print("AIHDIK")
		if player_position == Player_positions.THIRDHALLWAY2_BACK_POSITION:
			player.position = get_tree().root.get_node("/root/"+ current_scene.name + "/ThirdHallway2BackPosition").position	
	
		
