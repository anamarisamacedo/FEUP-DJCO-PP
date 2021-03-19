extends Node2D


func _on_Back_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://MainScene.tscn")


func _on_Door1_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/Rooms/B020Scene.tscn")


func _on_Door2_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/Rooms/B021Scene.tscn")
