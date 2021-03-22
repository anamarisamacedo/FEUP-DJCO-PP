extends Node2D

var player
var bookFound = false

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	player.position = $Position2D.position

func _on_Shelf2_body_entered(body):
	if body.name == "Player":
		if(bookFound == false):
			bookFound = true
			$AnimationPlayer.play("Book")
			print(player)
			player.add_book()


func _on_back_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/ThirdHallway.tscn")

