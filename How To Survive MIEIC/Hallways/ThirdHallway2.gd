extends Node2D

var player 

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	player.position = $Position2D.position
	if GlobalVariables.beerThirdHallway2Picked == true:
		get_tree().root.get_node("/root/ThirdHallway2/Beer").queue_free()

func _on_Door1_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/Rooms/B130Scene.tscn")


func _on_Door2_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/Rooms/B131Scene.tscn")

func _on_Elevator2_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/ThirdHallway.tscn")
		GlobalVariables.player_position = GlobalVariables.Player_positions.THIRDHALLWAY2_BACK_POSITION
