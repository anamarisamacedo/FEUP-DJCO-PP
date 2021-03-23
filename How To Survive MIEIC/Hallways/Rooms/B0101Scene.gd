extends Node2D

var player 

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	player.position = $Position2D.position
	
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/FirstHallway.tscn")


func _on_project_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("Project")
		player.has_Carlos_project = true
