extends Area2D


# Declare member variables here. Examples:
var player

func _ready():
	player = get_tree().root.get_node("/root/MainScene/Player")


func _on_Book_body_entered(body):
	if body.name == "Player":
		get_tree().queue_delete(self)
		player.add_book()
