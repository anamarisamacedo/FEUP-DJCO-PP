extends Node2D

var player 

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	player.position = $Position2D.position
	if GlobalVariables.beerSecondHallwayPicked == true:
		get_tree().root.get_node("/root/SecondHallway/Beer").queue_free()

func _on_Back_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://MainScene.tscn")


func _on_Door1_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/Rooms/B020Scene.tscn")


func _on_Door2_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/Rooms/B021Scene.tscn")
