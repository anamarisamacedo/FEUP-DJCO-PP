extends Node2D

var player 

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	player.position = $Position2D.position
	
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/SecondHallway.tscn")


func _on_Book_body_entered(body):
	if body.name == "Player":
		if(GlobalVariables.bookB020Found == false):
			GlobalVariables.bookB020Found = true
			$AnimationPlayer.play("Book")
			player.add_book()
