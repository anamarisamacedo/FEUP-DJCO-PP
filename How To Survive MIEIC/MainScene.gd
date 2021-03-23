extends Node2D

var player 

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	if GlobalVariables.bookMainScenePicked == true:
		get_tree().root.get_node("/root/MainScene/Book").queue_free()
	if GlobalVariables.beerMainScenePicked == true:
		get_tree().root.get_node("/root/MainScene/Beer").queue_free()

func _on_FirstHallway_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/FirstHallway.tscn")

func _on_SecondHallway_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/SecondHallway.tscn")


func _on_ThirdHallway_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/ThirdHallway.tscn")


func _on_OutsideDoor_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Outside.tscn")


func _on_Book_body_entered(body):
	if body.name == "Player":
		get_tree().root.get_node("/root/MainScene/Book").queue_free()
		player.add_book()
		GlobalVariables.bookMainScenePicked = true
