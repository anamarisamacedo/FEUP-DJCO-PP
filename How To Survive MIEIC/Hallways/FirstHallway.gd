extends Node2D

var player

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	player.position = $Position2D.position

func _on_Back_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://MainScene.tscn")


func _on_Door1_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/Rooms/B010Scene.tscn")


func _on_Door2_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/Rooms/B011Scene.tscn")
