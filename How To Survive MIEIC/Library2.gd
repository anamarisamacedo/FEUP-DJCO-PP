extends Node2D

var player 

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	player.position = $Position2D.position
	
func _on_elevator_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Library.tscn")


func _on_shelfBook_body_entered(body):
	if body.name == "Player":
		if(GlobalVariables.bookLibrary2Found == false):
			GlobalVariables.bookLibrary2Found = true
			$AnimationPlayer.play("Book")
			player.add_book()
