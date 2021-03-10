extends Area2D


# Declare member variables here. Examples:
var teacher

func _ready():
	teacher = get_tree().root.get_node("/root/MainScene/NPC_Professor")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Book_body_entered(body):
	if body.name == "Player":
		get_tree().queue_delete(self)
		teacher.bookFound = true
