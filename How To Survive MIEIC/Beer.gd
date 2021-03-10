extends Area2D

var player

func _ready():
	player = get_tree().root.get_node("/root/MainScene/Player")

func _on_Beer_body_entered(body):
	if body.name == "Player":
		print(get_tree().root)
		get_tree().queue_delete(self)
		player.add_beer()
