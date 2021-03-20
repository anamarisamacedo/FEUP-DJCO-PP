extends Node2D


func _on_Door1_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/Rooms/B130Scene.tscn")


func _on_Door2_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/Rooms/B131Scene.tscn")



func _on_Elevator_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/ThirdHallway.tscn")
