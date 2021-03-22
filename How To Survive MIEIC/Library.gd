extends Node2D

var player 

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	player.position = $Position2D.position

func _on_back_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Outside.tscn")


func _on_stairs_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Library2.tscn")


func _on_shelf_body_entered(body):
	if body.name == "Player":
		if(GlobalVariables.bookLibraryFound == false):
			GlobalVariables.bookLibraryFound = true
			$AnimationPlayer.play("Book")
			player.add_book()
