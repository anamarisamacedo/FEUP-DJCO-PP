extends Node2D

var player 

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	player.position = $Position2D.position
	if GlobalVariables.beerOutsidePicked == true:
		get_tree().root.get_node("/root/Outside/Beer").queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Library.tscn")


func _on_B_building_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://MainScene.tscn")
