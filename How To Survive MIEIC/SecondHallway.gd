extends Node2D


func _on_Back_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://MainScene.tscn")
