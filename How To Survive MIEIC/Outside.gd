extends Node2D



func _on_Area2D_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Library.tscn")


func _on_B_building_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://MainScene.tscn")
