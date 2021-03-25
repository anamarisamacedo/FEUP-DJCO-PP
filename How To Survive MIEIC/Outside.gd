extends Node2D

var player 

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	if GlobalVariables.beerOutsidePicked == true:
		get_tree().root.get_node("/root/Outside/Beer").queue_free()
	if GlobalVariables.beerOutside2Picked == true:
		get_tree().root.get_node("/root/Outside/Beer2").queue_free()
	if GlobalVariables.quest_status_praxis_project == GlobalVariables.QuestStatus.PROJECT:
		get_tree().root.get_node("/root/Outside/NPC_Praxis2").queue_free()

func _on_B_building_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://MainScene.tscn")
		GlobalVariables.player_position = GlobalVariables.Player_positions.OUTSIDE_BACK_POSITION


func _on_Library_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Library.tscn")
