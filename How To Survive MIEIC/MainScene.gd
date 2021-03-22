extends Node2D


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
